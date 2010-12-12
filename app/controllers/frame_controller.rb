class FrameController < ApplicationController
  
  before_filter :load_matrix, :only => [:show, :create, :update, :destroy]
  before_filter :get_frame_nr, :only => [:show, :update, :destroy]
  
  def index    
  end
  
  #show a frame
  def show
    @matrix.current_frame_nr = @current_frame_nr
  end  
  
  #def create a frame
  def create
    @current_frame_nr = @matrix.add_frame( params[:last_frame_nr] )
    @matrix.save!
    redirect_to matrix_frame_path(@matrix.id, @current_frame_nr)
  end

  def update
    @matrix.toggle_pixel(@current_frame_nr, params[:x].to_i, params[:y].to_i)
    @matrix.save!
    redirect_to matrix_frame_path(@matrix.id, @current_frame_nr)
  end
  
  #destroy a frame
  def destroy
    @current_frame_nr = @matrix.delete_frame(@current_frame_nr) if @matrix.num_frames > 1
    @matrix.save!
    redirect_to matrix_frame_path(@matrix.id, @current_frame_nr)
  end
  

  private
  def load_matrix
    @matrix = Matrix.find params[:matrix_id]
  end
  
  def get_frame_nr
    @current_frame_nr = params[:id].to_i
  end  
  
end
