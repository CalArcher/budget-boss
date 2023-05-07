class UserCommandsController < ApplicationController
  before_action :set_user_command, only: %i[ show update destroy ]

  # GET /user_commands
  def index
    @user_commands = UserCommand.all

    render json: @user_commands
  end

  # GET /user_commands/1
  def show
    render json: @user_command
  end

  # POST /user_commands
  def create
    @user_command = UserCommand.new(user_command_params)

    if @user_command.save
      render json: @user_command, status: :created, location: @user_command
    else
      render json: @user_command.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_commands/1
  def update
    if @user_command.update(user_command_params)
      render json: @user_command
    else
      render json: @user_command.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_commands/1
  def destroy
    @user_command.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_command
      @user_command = UserCommand.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_command_params
      params.require(:user_command).permit(:body)
    end
end
