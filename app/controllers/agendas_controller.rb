class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]
  # after_destroy :agenda_destroy_mail

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy
    if @current_user == @agenda.team.owner || @current_user == @agenda.user
      @agenda.destroy
      redirect_to dashboard_path, notice:"agendaを削除しました！"
      @agenda_team = []
      @agenda_team << @agenda.team
      @agenda_team.each_with_index do |x, i|
        AssignMailer.agenda_destroy_mail(x.users[i][:email]).deliver
      end
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
