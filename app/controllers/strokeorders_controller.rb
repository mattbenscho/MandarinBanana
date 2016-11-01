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

    unit_distance = 10

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
        stroke = tries[try_index][stroke_index]
        stroke_length = tries_stroke_lengths[try_index][stroke_index]
        this_unit_distance = stroke_length / samples
        new_points = []
        distances = tries_distances[try_index][stroke_index]
        deltas = tries_deltas[try_index][stroke_index]
        moved = 0
        current_position_index = 0
        for sample in 0..samples - 1
          target = (sample+1) * this_unit_distance
          while moved < target
            distance = distances[current_position_index] || distances[-1]
            if moved + distance > target
              current_position = stroke[current_position_index] || stroke[-1]
              percent = (target - moved) / this_unit_distance
              delta = deltas[current_position_index] || deltas[-1]
              delta_x = delta[0]
              delta_y = delta[1]
              new_x = current_position[0] + percent * delta_x
              new_y = current_position[1] + percent * delta_y
              new_points.push([new_x, new_y])
            end
            current_position_index += 1
            moved += distance
          end
        end

        while new_points.length < samples
          new_points.push([stroke[-1][0], stroke[-1][1]])
        end
        puts new_points.length
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
        new_points.push([x.round, y.round])
      end
      averaged_points.push(new_points)
    end
    
    @strokeorder.strokes = averaged_points.to_s

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
    @hanzi = Hanzi.find(@strokeorder.hanzi_id)
    @user = User.find(@strokeorder.user_id)
    @strokes = @strokeorder.strokes
  end

  private

    def strokeorder_params
      params.require(:strokeorder).permit(:hanzi_id, :strokes, :user_id)
    end
end
