class TeachersController < ApplicationController
  include Pagy::Method
  
  before_action :set_teacher, only: %i[ show edit update destroy remove_subject ]

  def index
    @q = Teacher.ransack(params[:q])
    @pagy, @teachers = pagy(
      :offset,
      @q.result(distinct: true).includes(:department).order(:id),
      limit: 10
    )
  end

  def show
    @teacher_url = teacher_url(@teacher)
    @qr_code = RQRCode::QRCode.new(@teacher_url)
  end

  def new
    @teacher = Teacher.new
  end

  def edit
  end

  def create
    @teacher = Teacher.new(teacher_params)
    department = Department.find_by(id: params[:from_department])

    respond_to do |format|
      if @teacher.save
        format.html {
          redirect_to department || @teacher,
          notice: "Teacher was successfully created."
        }
      else
        format.html do
          if department
            redirect_to department,
              alert: @teacher.errors.full_messages.to_sentence,
              status: :see_other
          else
            render :new, status: :unprocessable_entity
          end
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html {
          redirect_to @teacher,
          notice: "Teacher was successfully updated.",
          status: :see_other
        }

        format.json {
          render :show,
          status: :ok,
          location: @teacher
        }
      else
        format.html {
          render :edit,
          status: :unprocessable_content
        }

        format.json {
          render json: @teacher.errors,
          status: :unprocessable_content
        }
      end
    end
  end

  def destroy
    department = Department.find_by(id: params[:from_department])
    @teacher.destroy!

    respond_to do |format|
      format.html {
        redirect_to department || teachers_path,
        notice: "Teacher was successfully destroyed.",
        status: :see_other
      }

      format.json {
        head :no_content
      }
    end
  end

  def remove_subject
    subject = @teacher.subjects.find(params[:subject_id])

    if subject.update(teacher_id: nil)
      redirect_to edit_teacher_path(@teacher),
        notice: "Subject was successfully removed from the teacher."
    else
      redirect_to edit_teacher_path(@teacher),
        alert: "Unable to remove subject."
    end
  end

  private

  def set_teacher
    @teacher = Teacher.friendly.find(params.expect(:id))
  end

  def teacher_params
    params.expect(
      teacher: [
        :name,
        :email,
        :specialization,
        :department_id,
        :per_unit_rate
      ]
    )
  end
end