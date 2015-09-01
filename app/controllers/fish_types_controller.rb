class FishTypesController < ApplicationController
  before_action :set_fish_type, only: [:show, :edit, :update, :destroy]

  # GET /fish_types
  # GET /fish_types.json
  def index
    @fish_types = FishType.all
  end

  # GET /fish_types/1
  # GET /fish_types/1.json
  def show
  end

  # GET /fish_types/new
  def new
    @fish_type = FishType.new
  end

  # GET /fish_types/1/edit
  def edit
  end

  # POST /fish_types
  # POST /fish_types.json
  def create
    @fish_type = FishType.new(fish_type_params)

    respond_to do |format|
      if @fish_type.save
        format.html { redirect_to @fish_type, notice: 'Fish type was successfully created.' }
        format.json { render :show, status: :created, location: @fish_type }
      else
        format.html { render :new }
        format.json { render json: @fish_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fish_types/1
  # PATCH/PUT /fish_types/1.json
  def update
    respond_to do |format|
      if @fish_type.update(fish_type_params)
        format.html { redirect_to @fish_type, notice: 'Fish type was successfully updated.' }
        format.json { render :show, status: :ok, location: @fish_type }
      else
        format.html { render :edit }
        format.json { render json: @fish_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fish_types/1
  # DELETE /fish_types/1.json
  def destroy
    @fish_type.destroy
    respond_to do |format|
      format.html { redirect_to fish_types_url, notice: 'Fish type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fish_type
      @fish_type = FishType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fish_type_params
      params.require(:fish_type).permit(:name, :point_value)
    end
end
