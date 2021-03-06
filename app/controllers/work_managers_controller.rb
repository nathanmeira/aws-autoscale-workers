class WorkManagersController < ApplicationController

  before_action :set_application
  before_action :set_work_manager, only: [:show, :edit, :update, :destroy, :active, :check, :clear_cycles]

  def show
  end

  def new
    @work_manager = @application.work_managers.new
  end

  def edit
  end

  def create
    @work_manager = @application.work_managers.new(work_manager_params)
    @work_manager.save
    respond_with(@application, @work_manager)
  end

  def update
    @work_manager.update(work_manager_params)
    respond_with(@application, @work_manager)
  end

  def destroy
    @work_manager.destroy
    respond_with(@application, @work_manager, location: application_path(@application))
  end

  def check
    begin
      CheckService.new(@work_manager).check
      flash[:success] = 'Checagem Efetuada!'
    rescue => e
      flash[:error] = 'Ocorreu um erro ao tentar efetuar a checagem: %s' % e.message
    end
    redirect_to [@application, @work_manager]
  end

  def clear_cycles
    @work_manager.cycles.destroy_all
    respond_with(@application, @work_manager)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_work_manager
    @work_manager = @application.work_managers.find(params[:id])
  end

  def set_application
    @application = Application.find(params[:application_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_manager_params
    params.require(:work_manager).permit(:id, :name, :aws_region, :autoscalinggroup_name, :queue_name, :max_workers, :min_workers, :minutes_to_process, :jobs_per_cycle, :active)
  end

end