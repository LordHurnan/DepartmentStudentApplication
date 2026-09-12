class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[ show edit update destroy ]

  # GET /teachers or /teachers.json
  def index
    @teachers = Teacher.all
  end

  # GET /teachers/1 or /teachers/1.json
  def show
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers or /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)
    department = Department.find_by(id: params[:from_department])

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to department || @teacher, notice: "Teacher was successfully created." }
      else
        format.html do
          if department
            redirect_to department, alert: @teacher.errors.full_messages.to_sentence, status: :see_other
          else
            render :new, status: :unprocessable_entity
          end
        end
      end
    end
  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: "Teacher was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @teacher.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /teachers/1 or /teachers/1.json
  def destroy
    department = Department.find_by(id: params[:from_department])
    @teacher.destroy!

    respond_to do |format|
      format.html { redirect_to department || teachers_path, notice: "Teacher was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.expect(teacher: [ :name, :email, :specialization, :department_id ])
    end
end
