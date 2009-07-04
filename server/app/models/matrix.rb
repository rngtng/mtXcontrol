class Matrix < ActiveRecord::Base
  
  validates_presence_of :x, :y, :name
  serialize :frames
  
  before_create :add_frame
    
  before_save :write_frame
  
  #attr_reader :x, :y
  
  def frames
    @frames ||= attributes['frames'] || []
  end
  
  def num_frames
    frames.size
  end
  
  def y
    attributes['y']
  end
  alias_method :rows, :y
  
  def x
    attributes['x']
  end
  alias_method :columns, :x
  
  def next_frame_nr
    (current_frame_nr + 1 ) % num_frames  # (current_frame_nr >= frames.size() - 1) ? 0 : current_frame_nr + 1;
  end

  def current_frame_nr
    @current_frame_nr ||= 0
  end
  
  def previous_frame_nr
    (current_frame_nr == 0 ) ? num_frames - 1 : current_frame_nr - 1;
  end

  def current_frame_nr=(frame_nr)
    @current_frame_nr = frame_nr % num_frames
  end

  ## +++++++++++++++ DATA STRUCTURE +++++++++++++++ */
  def current_frame
    frames[current_frame_nr]
  end

  def current_row(c_y)
    row(current_frame_nr, c_y)
  end

  def current_pixel(c_x, c_y)
    pixel(current_frame_nr, c_x, c_y);
  end

  def toggle_current_pixel( c_x, c_y )
    toggle_pixel(current_frame_nr, c_x, c_y )
  end
  
  def row(f, c_y)
    frames[f][c_y]
  end

  def pixel(f, c_x, c_y)
    (row(f, c_y) & (1 << c_x)) > 0
  end

  def toggle_pixel( f, c_x, c_y )
    return if c_x >= x || c_y >= y
    frames[f][c_y] = row(f,c_y) ^ (1 << c_x)
  end

  ## +++++++++++++++ FRAME +++++++++++++++ */
  def add_frame(frame_nr = current_frame_nr, values = nil)
    values ||= ([0] * y)
    frames.insert(frame_nr.to_i + 1, values) #init first frame
    current_frame_nr = frame_nr.to_i + 1
  end
  
  def delete_frame(frame_nr = current_frame_nr)
    return unless (0...num_frames).include?(frame_nr)
    frames.delete_at(frame_nr)
    @current_frame_nr = (frame_nr % num_frames)
  end

  def copy_last_frame(frame_nr = current_frame_nr)
    return if frame_nr == 0
    frames[f] = frames[current_frame_nr-1].clone
  end

  def clear_frame(frame_nr = current_frame_nr)
    set_frame(frame_nr, 0);
  end

  
  def fill_frame(frame_nr = current_frame_nr)
    set_frame(frame_nr, (1 << x) - 1 )
  end


  def set_frame( f, &block) 
    y.times do |y|
      frames[f][y] = block.call(y) || 0
    end
  end

  private 
  def write_frame
    write_attribute :frames, @frames
  end
end


  # def initialize( x, y)
  #   x = x
  #   y = y
  #   frames = []
  #   current_frame_nr = 0
  #   add_frame    
  # end
  
  # def x
  #   x
  # end
 # alias_method :columns, :x
  
  # def y
  #   y
  # end
#  alias_method :rows, :y
