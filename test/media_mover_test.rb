begin
  require 'rubygems'
  require 'test/unit'
  require 'fileutils'
  require 'shoulda'
rescue
  puts "Shoulda gem required to run tests. gem install shoulda."
  exit 1
end

class MediaMoverTest < Test::Unit::TestCase
  include FileUtils
  
  def setup
    @downloads_dir = File.join(File.dirname(__FILE__), *%w[tmp downloads])
    @tv_dir = File.join(File.dirname(__FILE__), *%w[tmp tv])
    @movie_dir = File.join(File.dirname(__FILE__), *%w[tmp movies])
    
    mkdir_p @downloads_dir
    mkdir_p @tv_dir
    mkdir_p @movie_dir
  end
  
  def teardown
    rm_rf File.join(File.dirname(__FILE__), *%w[tmp])
    rm_f "/tmp/media-mover.lock"
  end
  
  context "Moving TV shows" do

    should "move files matching [TV SHOW].SXEYY.avi" do
      show_name = "The Simpsons.S02E13.avi"
      touch File.join(@downloads_dir, show_name)
      assert do_media_mover!
      assert File.exist?(File.join(@tv_dir, 'The.Simpsons', 'Season 2', 'The.Simpsons.S02E13.avi'))
    end
    
    should "move files matching [TV SHOW] SXEYY.avi" do
      show_name = "The Simpsons S02E13.avi"
      touch File.join(@downloads_dir, show_name)
      assert do_media_mover!
      assert File.exist?(File.join(@tv_dir, 'The.Simpsons', 'Season 2', 'The.Simpsons.S02E13.avi'))
    end
    
    should "move files matching [TV SHOW] - SXEYY.avi" do
      show_name = "The Simpsons - S02E13.avi"
      touch File.join(@downloads_dir, show_name)
      assert do_media_mover!
      assert File.exist?(File.join(@tv_dir, 'The.Simpsons', 'Season 2', 'The.Simpsons.S02E13.avi'))
    end
    
    should "move files matching [TV SHOW].SxEE.avi" do
      show_name = "The Simpsons.2x13.avi"
      touch File.join(@downloads_dir, show_name)
      assert do_media_mover!
      assert File.exist?(File.join(@tv_dir, 'The.Simpsons', 'Season 2', 'The.Simpsons.S02E13.avi'))
    end
    
    should "move files matching [TV SHOW] SxEE.avi" do
      show_name = "The Simpsons 2x13.avi"
      touch File.join(@downloads_dir, show_name)
      assert do_media_mover!
      assert File.exist?(File.join(@tv_dir, 'The.Simpsons', 'Season 2', 'The.Simpsons.S02E13.avi'))
    end
    
    should "move files matching [TV SHOW] - SxEE.avi" do
      show_name = "The Simpsons - 2x13.avi"
      touch File.join(@downloads_dir, show_name)
      assert do_media_mover!
      assert File.exist?(File.join(@tv_dir, 'The.Simpsons', 'Season 2', 'The.Simpsons.S02E13.avi'))
    end
    
  end
  
  def do_media_mover!(other_options = '')
    bin_path = File.join(File.dirname(__FILE__), *%w[.. bin media-mover])
    system("perl #{bin_path} -no-update-plex -k -d #{@downloads_dir} -t #{@tv_dir} -m #{@movie_dir} #{other_options}")
  end
end