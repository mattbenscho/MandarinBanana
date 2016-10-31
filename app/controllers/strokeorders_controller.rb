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

    unit_distance = 2

    strokecounter = 0
    for strokes in tries
      trycounter = 0
      stroke_length_list = []
      distances_list = []
      deltas_list = []
      avg_stroke_length = 0
      # calculate distances and incremental translations
      for stroke in strokes
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
        trycounter += 1
        avg_stroke_length += stroke_length
        distances_list.push(distances);
        deltas_list.push(deltas)
      end
      avg_stroke_length /= stroke_length_list.length
      samples = (avg_stroke_length / unit_distance).round

      if samples < 1
        next
      end

      # interpolate linearly
      new_points_list = []

      trycounter = 0
      for stroke in tries[strokecounter]
        if stroke.empty?
          next
        end
        stroke_length = stroke_length_list[trycounter]
        this_unit_distance = stroke_length / samples
        new_points = []
        distances = distances_list[trycounter]
        deltas = deltas_list[trycounter]
        moved = 0
        current_position_index = 0
        for sample in 0..samples
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
        new_points_list.push(new_points)

        trycounter += 1
      end

      strokecounter += 1
    end

    @strokeorder.strokes = new_points_list.to_s

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
