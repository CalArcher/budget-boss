class SheetsController < ApplicationController
  before_action :set_sheet, only: %i[ show update destroy ]

  # GET /sheets
  def index
    @sheets = Sheet.all

    render json: @sheets
  end

  # GET /sheets/1
  def show
    render json: @sheet
  end

  # POST /sheets
  def create
    @sheet = Sheet.new(sheet_params)

    if @sheet.save
      render json: @sheet, status: :created, location: @sheet
    else
      render json: @sheet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sheets/1
  def update
    if @sheet.update(sheet_params)
      render json: @sheet
    else
      render json: @sheet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sheets/1
  def destroy
    @sheet.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sheet
      @sheet = Sheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sheet_params
      params.require(:sheet).permit(:month)
    end
end
