class TextSendsController < ApplicationController
  before_action :set_text_send, only: %i[ show update destroy ]

  # GET /text_sends
  def index
    @text_sends = TextSend.all

    render json: @text_sends
  end

  # GET /text_sends/1
  def show
    render json: @text_send
  end

  # POST /text_sends
  def create
    @text_send = TextSend.new(text_send_params)

    if @text_send.save
      render json: @text_send, status: :created, location: @text_send
    else
      render json: @text_send.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /text_sends/1
  def update
    if @text_send.update(text_send_params)
      render json: @text_send
    else
      render json: @text_send.errors, status: :unprocessable_entity
    end
  end

  # DELETE /text_sends/1
  def destroy
    @text_send.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text_send
      @text_send = TextSend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def text_send_params
      params.require(:text_send).permit(:body)
    end
end
