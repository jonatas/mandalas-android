require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView, :ImageView, :SeekBar
%w{Animation RotateAnimation LinearInterpolator}.each do |_clazz|
  java_import "android.view.animation.#{_clazz}"
end


class MandalaActivity
  @@mandalas = [
    $package::R.drawable.mandala_1_01b, $package::R.drawable.mandala_1_02b, $package::R.drawable.mandala_1_03b, $package::R.drawable.mandala_1_04b,
    $package::R.drawable.mandala_1_05b, $package::R.drawable.mandala_1_06b, $package::R.drawable.mandala_1_07b, $package::R.drawable.mandala_1_08b,
    $package::R.drawable.mandala_1_09b, $package::R.drawable.mandala_1_010b, $package::R.drawable.mandala_1_011b, $package::R.drawable.mandala_1_012b,
    $package::R.drawable.mandala_1_013b, $package::R.drawable.mandala_1_014b, $package::R.drawable.mandala_1_015b, $package::R.drawable.mandala_1_016b,
    $package::R.drawable.mandala_1_017b, $package::R.drawable.mandala_1_018b, $package::R.drawable.mandala_1_019b, $package::R.drawable.mandala_1_020b,
    $package::R.drawable.mandala_1_021b, $package::R.drawable.mandala_1_022b, $package::R.drawable.mandala_1_023b, $package::R.drawable.mandala_1_024b,
    $package::R.drawable.mandala_1_025b, $package::R.drawable.mandala_1_026b
  ]
  def onCreate(bundle)
    super
    @index = 0
    self.content_view =
      linear_layout :orientation => :vertical do
        @mandala = image_view :image_resource => @@mandalas[@index],
          :scale_type => ImageView::ScaleType::FIT_CENTER,
#          :on_touch_listener => proc{|view, motion_event|change_mandala_speed(view,motion_event)},
          :on_click_listener => proc{|v| pause_mandala(v) },
          :layout => {
            :weight= => 1,
            :height= => :fill_parent,
            :width= => :fill_parent}
        
        linear_layout do
          button :text => "<", :on_click_listener => proc{|v| previous_mandala }
          button :text => "=", :on_click_listener => proc{|v| pause_mandala(v) }
          button :text => ">", :on_click_listener => proc{|v| next_mandala }
          seek_bar :on_seek_bar_change => proc{|view, progress_changed| change_mandala_speed(view, progress_changed)},
            :layout => { :height => :fill_parent, :width => :fill_parent}
        end

        @animation = RotateAnimation.new(0.0, 360.0,  RotateAnimation::RELATIVE_TO_SELF, 0.5, RotateAnimation::RELATIVE_TO_SELF, 0.5)
        @animation.setInterpolator LinearInterpolator.new()
        @animation.setRepeatCount Animation::INFINITE
        @animation.setDuration 500

        @mandala.startAnimation @animation
      end

  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end
  def next_mandala
    if @index < @@mandalas.size
      @mandala.image_resource =  @@mandalas[@index += 1]
    else
      @@mandalas[@index = 0]
    end
  end
  def pause_mandala v
    if v.text == "="
      v.text = "o"
      @mandala.clearAnimation
    else
      v.text = "="
      @mandala.startAnimation @animation
    end
  end
  def previous_mandala
    @mandala.image_resource =
      if @index > 0
        @@mandalas[@index -= 1]
      else
        @@mandalas[@index = @@mandalas.size - 1]
      end
  end
  def change_mandala_speed v,event
    android.util.Log.info "change mandala speed",event.to_s
    @animation.setDuration(event.progress / 1000)
  end
end
