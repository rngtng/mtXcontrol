class MatrixController < ApplicationController
  
 def show
   @matrix = Matrix.find params[:id]
   redirect_to matrix_frame_path( :matrix_id => @matrix.id, :id => 0)
 end  
 
end
