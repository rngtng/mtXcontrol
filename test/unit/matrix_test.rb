require 'test_helper'

class MatrixTest < ActiveSupport::TestCase
  
  test "create matrix" do
    m = Matrix.create :x => 5, :y => 5, :name => 'test'
    assert_equal 5, m.x
    assert_equal 5, m.y 
    assert_equal 'test', m.name
    assert_equal 1, m.num_frames
    assert_equal [0,0,0,0,0], m.frames.first    
  end

  test "add frame" do
    m = matrices(:test)
    m.add_frame
    assert_equal 2, m.num_frames
    assert_equal [0,0,0,0,0], m.frames.last
  end

  test "add frame in between" do
    m = matrices(:small)
    m.add_frame(3)
    assert_equal 6, m.num_frames
    assert_equal [[0],[1],[2],[0],[3],[4]], m.frames
  end

  test "delete frame" do
    m = matrices(:small)
    m.delete_frame
    assert_equal 4, m.num_frames
    assert_equal [[1],[2],[3],[4]], m.frames
  end

  test "delete frame in between" do
    m = matrices(:small)
    m.delete_frame(3)
    assert_equal 4, m.num_frames
    assert_equal [[0],[1],[2],[4]], m.frames
  end

  test "toggle pixel" do
    m = matrices(:test)
    assert !m.pixel(0, 0, 0)
    m.toggle_pixel(0, 0, 0)
    assert m.pixel(0, 0, 0)
  end
  
end
