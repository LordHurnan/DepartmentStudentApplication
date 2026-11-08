require "rqrcode"

class StudentsController < ApplicationController
  include Pagy::Method

  before_action :set_student, only: %i[ show edit update destroy ]

  def index
    @q = Student.ransack(params[:q])
    @pagy, @students = pagy(
      :offset,
      @q.result(distinct: true).includes(:department).order(:id),
      limit: 10
    )
  end

  def show
    @classlist = Classlist.new(student: @student)
    @available_sections = Section.where.not(id: @student.section_ids).order(:name)

    @student_url = student_url(@student)
    @qr_code = RQRCode::QRCode.new(@student_url)
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)
    department = Department.find_by(id: params[:from_department])

    respond_to do |format|
      if @student.save
        format.html { redirect_to department || @student, notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html do
          if department
            redirect_to department, alert: @student.errors.full_messages.to_sentence, status: :see_other
          else
            render :new, status: :unprocessable_entity
          end
        end
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    department = Department.find_by(id: params[:from_department])
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to department || students_path, notice: "Student was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_student
    @student = Student.friendly.find(params.expect(:id))
  end

  def student_params
    params.expect(student: [ :name, :year_level, :program, :department_id ])
  end
end