class StrokeordersController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]

  def new
    @hanzi = Hanzi.find(params[:hanzi_id])
    @strokeorder = Strokeorder.new
    @user = current_user
  end

  def create
    @strokeorder = Strokeorder.new(strokeorder_params)
    tries = JSON.parse(@strokeorder.strokes)

    unit_distance = 1
    moving_points = 50

    # are there any duplicate points?
    to_check = 2
    while (to_check > 0)
      # print "going to check once more\n"
      filtered_tries = []
      doubles = false
      deletion_indices = []
      trycounter = 0
      for this_try in tries
        strokecounter = 0
        f_strokes = []
        for this_stroke in this_try
          pointcounter = 0
          last_x = this_stroke[0][0]
          last_y = this_stroke[0][1]
          f_points = []
          for this_point in this_stroke
            this_x = this_point[0]
            this_y = this_point[1]
            if this_x == last_x and this_y == last_y and pointcounter > 0
              if not doubles
                doubles = true
                # print "there are still doubles!\n"
                to_check += 1
              end
              # print "#{trycounter} #{strokecounter} #{pointcounter}: #{this_x}, #{this_y}\n"
            else
              if this_x.between?(0, 400) and this_y.between?(0, 400)
                f_points.push([this_x, this_y])
              end
            end
            last_x = this_x
            last_y = this_y
            pointcounter += 1
          end
          if not f_points.empty?
            f_strokes.push(f_points)
          end
          strokecounter += 1
        end
        if not f_strokes.empty?
          filtered_tries.push(f_strokes)
        end
        trycounter += 1
      end

      if not doubles
        # print "no doubles left.\n"
        to_check -= 1
      end
      
      tries = filtered_tries
    end

    # handle each try separately to get information
    # calculate distances and incremental translations
    # just information gathering, nothing happening yet
    tries_stroke_lengths = []
    tries_distances = []
    tries_deltas = []
    number_of_tries = tries.length
    for this_try in tries
      stroke_length_list = []
      distances_list = []
      deltas_list = []
      for stroke in this_try
        if stroke.empty?
          next
        end
        last_x = stroke[0][0]
        last_y = stroke[0][1]
        distances = []
        deltas = []
        stroke_length = 0
        for point in stroke
          this_x = point[0]
          this_y = point[1]
          delta_x = this_x - last_x
          delta_y = this_y - last_y
          distance = Math.sqrt(delta_x**2 + delta_y**2)
          stroke_length += distance
          distances.push(distance)
          deltas.push([delta_x, delta_y])
          last_x = this_x
          last_y = this_y
        end
        stroke_length_list.push(stroke_length)
        distances_list.push(distances);
        deltas_list.push(deltas)
      end
      tries_stroke_lengths.push(stroke_length_list)
      tries_distances.push(distances_list)
      tries_deltas.push(deltas_list)
    end

    all_new_points = []
    # now go through all tries for each stroke to interpolate them
    for stroke_index in 0..tries[0].length - 1
      # calculate the average length of this stroke
      avg_length = 0
      for try_index in 0..tries.length - 1
        avg_length += tries_stroke_lengths[try_index][stroke_index]
      end
      avg_length /= tries_stroke_lengths[try_index].length
      samples = (avg_length / unit_distance).round

      # interpolate this stroke linearly for each try
      this_stroke_new_points = []
      for try_index in 0..tries.length - 1
        puts "stroke: " + stroke_index.to_s + ", try: " + try_index.to_s
        stroke = tries[try_index][stroke_index]
        stroke_length = tries_stroke_lengths[try_index][stroke_index]
        this_unit_distance = stroke_length / samples
        new_points = []
        distances = tries_distances[try_index][stroke_index]
        deltas = tries_deltas[try_index][stroke_index]
        # find the new position of each sample
        current_position = stroke[0]
        last_point_index = 0
        percent = 0
        this_distance = 0
        # the first point is the first point
        new_points.push(current_position)
        print "new point: [", current_position[0], ", ", current_position[1], "]\n"
        for this_sample in 0..samples - 1
          # the distance from the last to the next spot:
          distance = distances[last_point_index]
          print this_sample, " ", this_distance, " ", distance, "\n"
          while this_distance + distance < this_unit_distance
            # puts "we need to move to the next point and a little further"
            this_distance += distance
            last_point_index += 1
            distance = distances[last_point_index] || distances[-1]
            print this_sample, " ", this_distance, " ", distance, "\n"
          end
          # the new point is somewhere between the last and the next point
          distance_left = this_unit_distance - this_distance
          percent = distance_left / distance
          delta = deltas[last_point_index] || deltas[-1]
          delta_x = delta[0]
          delta_y = delta[1]
          current_position = stroke[last_point_index] || stroke[-1]
          new_x = current_position[0] + percent * delta_x
          new_y = current_position[1] + percent * delta_y
          print "new point: [", new_x, ", ", new_y, "]\n"
          new_points.push([new_x, new_y])
          # we got the new point, lets go back to the last point for a new start
          this_distance = -Math.sqrt((percent * delta_x)**2 + (percent * delta_y)**2)
        end

        while new_points.length < samples
          new_points.push([stroke[-1][0], stroke[-1][1]])
        end
        this_stroke_new_points.push(new_points)
      end
      all_new_points.push(this_stroke_new_points)
    end

    # average the new strokes
    averaged_points = []
    for stroke_index in 0..all_new_points.length - 1
      new_points = []
      for point_index in 0..all_new_points[stroke_index][0].length - 1
        x = 0
        y = 0
        for try_index in 0..number_of_tries - 1
          x += all_new_points[stroke_index][try_index][point_index][0]
          y += all_new_points[stroke_index][try_index][point_index][1]
        end
        x /= number_of_tries
        y /= number_of_tries
        new_points.push([x, y])
      end
      averaged_points.push(new_points)
    end
    
    new_points = []
    # calculate the moving average for each stroke
    for stroke in averaged_points
      puts stroke.length
      stroke_moving_points = moving_points
      points_list = []
      # first points
      stroke_moving_points = stroke_moving_points >= stroke.length - 1 ? stroke.length - 1 : stroke_moving_points
      for this_moving_points in 2..stroke_moving_points
        point_x = 0
        point_y = 0
        for point_index in 0..this_moving_points - 1
          point_x += stroke[point_index][0]
          point_y += stroke[point_index][1]
        end
        points_list.push([(point_x/this_moving_points).round, (point_y/this_moving_points).round])
      end
      # middle points
      for avg_start in 0..stroke.length - stroke_moving_points - 1
        point_x = 0
        point_y = 0
        for point_index in avg_start..avg_start + stroke_moving_points - 1
          point_x += stroke[point_index][0]
          point_y += stroke[point_index][1]
        end
        points_list.push([(point_x/stroke_moving_points).round, (point_y/stroke_moving_points).round])
      end
      # end points
      for this_moving_points in stroke_moving_points.downto(2)
        point_x = 0
        point_y = 0
        for point_index in stroke.length - this_moving_points..stroke.length - 1
          point_x += stroke[point_index][0]
          point_y += stroke[point_index][1]
        end
        points_list.push([(point_x/this_moving_points).round, (point_y/this_moving_points).round])
      end
      new_points.push(points_list)
    end

    @strokeorder.strokes = new_points.to_s
    # @strokeorder.strokes = averaged_points.to_s

    if @strokeorder.save
      flash[:success] = "Stroke order information saved!"
      redirect_to @strokeorder
    else
      flash[:error] = "Error while trying to save stroke order information!"
      redirect_back_or root_url
    end
  end

  def show
    @strokeorder = Strokeorder.find(params[:id])
    @strokes = @strokeorder.strokes
    @hanzi = Hanzi.find(@strokeorder.hanzi_id)
    @user = User.find(@strokeorder.user_id)
  end

  private

    def strokeorder_params
      params.require(:strokeorder).permit(:hanzi_id, :strokes, :user_id)
    end
end
