class RankingsController < ApplicationController
  before_action :set_ranking, only: [:show, :edit, :update, :destroy]

  # GET /rankings
  # GET /rankings.json
  def index
    @rankings = Ranking.all
  end

  # GET /rankings/1
  # GET /rankings/1.json
  def show
  end

  # GET /rankings/new
  def new
    @ranking = Ranking.new
  end

  # GET /rankings/1/edit
  def edit
  end

  def eachRanking
    results = Ranking.where("puzzle_id = '#{params[:puzzle_id]}'").order('complete_time asc')
     @rankings = []

    for result in results
      @user = User.find(result.user_id)
      @rankings.push(:puzzle_id=>result.puzzle_id, :user_id=> result.user_id, :complete_time=>result.complete_time, :user_name=>@user.name)
    end

#    @rankings = Ranking.where("puzzle_id = '#{params[:puzzle_id]}'").order('complete_time asc')

  end

  # POST /rankings
  # POST /rankings.json
  def create
    puts "create---------------------------------------------------"
    puts "nil?-",params[:ranking][:puzzle_id]
    puts "nil?-",params[:ranking][:complete_time]


    @ranking = Ranking.new(ranking_params)
    @ranking.puzzle_id = params[:ranking][:puzzle_id]
    @ranking.complete_time = params[:ranking][:complete_time]
    @ranking.user_id = session[:login]

    respond_to do |format|
      if @ranking.save
        format.html { redirect_to @ranking, notice: 'Ranking was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ranking }
      else
        format.html { render action: 'new' }
        format.json { render json: @ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rankings/1
  # PATCH/PUT /rankings/1.json
  def update
    respond_to do |format|
      if @ranking.update(ranking_params)
        format.html { redirect_to @ranking, notice: 'Ranking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rankings/1
  # DELETE /rankings/1.json
  def destroy
    @ranking.destroy
    respond_to do |format|
      format.html { redirect_to rankings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ranking
      @ranking = Ranking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ranking_params
      params.require(:ranking).permit(:puzzle_id, :complete_time)
    end
end
