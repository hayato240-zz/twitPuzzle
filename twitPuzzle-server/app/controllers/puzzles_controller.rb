class PuzzlesController < ApplicationController
  before_action :check_login
  before_action :set_puzzle, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, lambda{|c| c.xml_http_request?}

  # GET /puzzles
  # GET /puzzles.json
  def index
    @puzzles = Puzzle.follow_timeline(session[:login])
    @puzzle_results = []
    for puzzle in @puzzles
      @puzzle_results.push(:id=>puzzle.id, :tweet=>puzzle.tweet, :image=>puzzle.image, :correct_order=>puzzle.correct_order, :name=>puzzle.user.name)
    end
  end

  def user_puzzle
      @puzzles = Puzzle.where("user_id=#{params[:user_id]}").order("created_at desc")
      @puzzle_results = []
      for puzzle in @puzzles
        @puzzle_results.push(:id=>puzzle.id, :tweet=>puzzle.tweet, :correct_order=>puzzle.correct_order, :name=>puzzle.user.name)
        puts "correct::", puzzle.correct_order
      end
  end

  # GET /puzzles/1
  # GET /puzzles/1.json
  def show
 
  end

  def get_image
   @puzzle = Puzzle.find(params[:id])
   send_data(@puzzle.image, :disposition => "inline", :type => "image/jpeg")
  end

  # GET /puzzles/new
  def new
    @puzzle = Puzzle.new
  end

  # GET /puzzles/1/edit
  def edit
  end

  # POST /puzzles
  # POST /puzzles.json
  def create
    @puzzle = Puzzle.new()
    puts "param:",params
    @puzzle.tweet = params[:puzzle][:tweet]
    @puzzle.correct_order = params[:puzzle][:correct_order]
    @puzzle.user_id = session[:login]

    if image = params[:puzzle][:image]
      @puzzle.image = image.read
    end

    respond_to do |format|
      if @puzzle.save
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @puzzle }
      else
        format.html { render action: 'new' }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /puzzles/1
  # PATCH/PUT /puzzles/1.json
  def update
    respond_to do |format|
        image = nil
        if image = params[:puzzle][:image]
          image = image.read
        end

        if @puzzle.update(:tweet => params[:puzzle][:tweet], :image =>image)
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puzzles/1
  # DELETE /puzzles/1.json
  def destroy
    @puzzle.destroy
    respond_to do |format|
      format.html { redirect_to puzzles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_puzzle
      @puzzle = Puzzle.find(params[:id])
    end
    

    def require_login
      if session[:login]
      else
        redirect_to new_login_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def puzzle_params
      params.require(:puzzle).permit(:tweet,:image)
    end

    def check_login

      puts session[:login]
      if session[:login]
        puts "aaaaaaaaaaaaaaaa"
        puts session[:login]
      else
        puts "session2:",session[:login]
        respond_to do |format|
            format.html { redirect_to new_login_path }
            format.json { head :no_content }
        end

      end

    end

end
