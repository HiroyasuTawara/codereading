class AgendasController < ApplicationController



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
    set_agenda
    permission_only_owner
    @emails = @agenda.team.users.pluck(:email)
    @title = @agenda.title
    @agenda.destroy
    AgendaMailer.deleat_mail(@emails, @agenda.title, current_user).deliver
    redirect_to dashboard_url, notice: 'アジェンダを削除しました'
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  def permission_only_owner
    unless Agenda.find(params[:id]).user_id.to_i == current_user.id || Agenda.find(params[:id]).team.owner_id.to_i == current_user.id
      redirect_to dashboard_url, notice: '削除権限がありません'
    end
  end

end
