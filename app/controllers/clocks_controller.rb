class ClocksController < ApplicationController
  before_action :set_clock, only: [:show, :edit, :update, :destroy]
  before_filter :check_administrative_ip, except: [:new, :create]
  # GET /clocks
  # GET /clocks.json
  def index

    @clocks = Clock.all
  end

  # GET /clocks/1
  # GET /clocks/1.json
  def show
    redirect_to new_clock_url
  end

  # GET /clocks/new
  def new
    @preset_ip=Setting.where(group: "ips", key: request.remote_ip).first
    @moment=Time.now.at_beginning_of_minute
    if @preset_ip.nil?
      @clock = Clock.new()
    else
      @clock = Clock.new(user: @preset_ip.value)
     end
  end

  # GET /clocks/1/edit
  #def edit
  #end

  # POST /clocks
  # POST /clocks.json
  def create
    clock_params[:message].strip!
    @clock = Clock.new(clock_params)
    @clock.date=Date.today
    @clock.time=Time.parse("#{params[:date][:hour]}:#{params[:date][:minute]}:00", @clock.date)
    @clock.ip=request.remote_ip
    @clock.pin=params[:pin]
    @moment=@clock.time.localtime # Time.now.at_beginning_of_minute
    #@moment=@moment.advance(minutes: -(@moment.min % 5))
    respond_to do |format|
      if @clock.save
        AdminMailer.timesheet(Date.today).deliver
        format.html { redirect_to new_clock_url, notice: "Registrazione #{@clock.action} per #{@clock.user} alle #{@clock.time} avvenuta con successo." }
        format.json { render :show, status: :created, location: @clock }
      else
        format.html { render :new }
        format.json { render json: @clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clocks/1
  # PATCH/PUT /clocks/1.json
  def update

    respond_to do |format|
      if @clock.update(clock_params)
        format.html { redirect_to @clock, notice: 'Clock was successfully updated.' }
        format.json { render :show, status: :ok, location: @clock }
      else
        format.html { render :edit }
        format.json { render json: @clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clocks/1
  # DELETE /clocks/1.json
  def destroy
    @clock.destroy
    respond_to do |format|
      format.html { redirect_to clocks_url, notice: 'Clock was successfully destroyed.' }
      format.json { head :no_content }
    end
    return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clock
      @clock = Clock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clock_params
      params.require(:clock).permit(:date, :time, :user, :ip, :action, :message)
    end


end
