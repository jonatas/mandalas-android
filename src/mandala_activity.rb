require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView, :ImageView
%w{Animation RotateAnimation LinearInterpolator}.each do |_clazz|
  java_import "android.view.animation.#{_clazz}"
end


class MandalaActivity
  @@mandalas = [
    $package::R.drawable.mandala_1_01b,
    $package::R.drawable.mandala_1_02b,
    $package::R.drawable.mandala_1_03b,
    $package::R.drawable.mandala_1_04b
  ]
  def onCreate(bundle)
    super
    set_title 'Mandalas Panel'
    @index = 0
    self.content_view = linear_layout do
      @mandala = image_view :image_resource => @@mandalas[@index],
                 :scale_type => ImageView::ScaleType::FIT_CENTER,
                 :on_click_listener => proc{|v| show_next_mandala(v)},
                 :layout => {
                   :weight= => 1,
                   :height= => :fill_parent,
                   :width= => :fill_parent}

      @animation = RotateAnimation.new(0.0, 360.0,  RotateAnimation::RELATIVE_TO_SELF, 0.5, RotateAnimation::RELATIVE_TO_SELF, 0.5)
      @animation.setInterpolator(LinearInterpolator.new())
      @animation.setRepeatCount(Animation::INFINITE)
      @animation.setDuration(700)

      @mandala.startAnimation(@animation);
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end
  def show_next_mandala view
    @mandala.image_resource = @index < @@mandalas.size ? @@mandalas[@index += 1] : @@mandalas[@index = 0]
  end
end
