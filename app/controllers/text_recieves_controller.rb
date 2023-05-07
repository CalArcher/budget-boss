class TextRecievesController < ApplicationController
  before_action :set_text_reciefe, only: %i[ show update destroy ]

  # GET /text_recieves
  def index
    @text_recieves = TextRecieve.all

    render json: @text_recieves
  end

  # GET /text_recieves/1
  def show
    render json: @text_reciefe
  end

  # POST /text_recieves
  def create
    @text_reciefe = TextRecieve.new(text_reciefe_params)

    if @text_reciefe.save
      render json: @text_reciefe, status: :created, location: @text_reciefe
    else
      render json: @text_reciefe.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /text_recieves/1
  def update
    if @text_reciefe.update(text_reciefe_params)
      render json: @text_reciefe
    else
      render json: @text_reciefe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /text_recieves/1
  def destroy
    @text_reciefe.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text_reciefe
      @text_reciefe = TextRecieve.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def text_reciefe_params
      params.require(:text_reciefe).permit(:body)
    end
end
