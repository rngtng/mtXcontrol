require 'serialport'

class Arduino
  BAUD_RATE  = 14400
  
  CRTL  = 255
  RESET = 255

  WRITE_FRAME  = 253
  WRITE_EEPROM = 252
  READ_EEPROM  = 251

  SPEED = 249
  SPEED_INC = 128 #B1000 0000
  SPEED_DEC = 1   #B0000 0001

  attr_reader :standalone

  def initialize(port = "/dev/tty.usbserial-A7006Qaq")
    @port = SerialPort.new(port, BAUD_RATE)    
    @standalone = true
  rescue   
    @port = nil
  end
  
  def close
    @port.close if @port
    @port = nil
  end
    
  ################################################################

  def write_frame(matrix)
    return if @standalone
    command( WRITE_FRAME )

    matrix.y.times do |y|
      send(matrix.current_row(y))
    end
  end

  def write_matrix(matrix)
    print("Start Writing Matrix - ")
    command( WRITE_EEPROM, matrix.numFrames, matrix.y )
    
    @matrix.num_frames.times do |f|
    @matrix.y.times do |y|
        send(matrix.row(f,y))
        sleep 1  #//we need this delay to give Arduino time consuming the Byte
      end      
    end    
    puts "Done"
  end

  def read_matrix
    print "Start Reading Matrix - " 
    command( READ_EEPROM )
    frames = wait_and_read_serial   
    puts  "Frames: #{frames}"
    num_y  = wait_and_read_serial
    matrix = Matrix.new(5, num_y)
    
    puts  "Rows: #{num_y}"
    @frames.times do |frame_nr|         
      puts "Frame Nr: #{frame_nr}"
      data = []
      @num_y.times do |row|   
        data << wait_and_read_serial
      end
      matrix.add_frame(data)      
    end
    
    puts "Done"
    return matrix
  end

  def toggle(matrix)
    if @standalone 
      @standalone = false
      write_frame(matrix)
      return
    end
    command(RESET)
    @standalone = true
  end

  def speed_up
    return unless @standalone
    command(SPEED, SPEED_INC)
  end

  def speed_down
    return unless @standalone
    command(SPEED, SPEED_DEC)
  end

  ################################################################

  private 
  def command(*commands)
    send(CRTL, *commands)
  end

  def send(*values)
    return unless @port
    values.each { |value| @port.write(value) }    
  end

  def wait_and_read_serial( cnt = 0 )    #add timeout value here
    while( @port.available < 1 )
      delay( 1 ) 
      cnt += 1
    end
    puts cnt
    @port.read
  end
  
end

