module RPiEPD
  module Devices
    class Waveshare7
      ##
      # A class with all the necessary information to run a
      # 7.5 inch EPD Waveshare device.
      # https://www.waveshare.com/wiki/7.5inch_e-Paper_HAT#Working_with_Raspberry_Pi
      ##

      # Display resolution
      @@width                                       = 640
      @@height                                      = 384

      # EPD7IN5 commands
      @@panel_setting                               = 0x00
      @@power_setting                               = 0x01
      @@power_off                                   = 0x02
      @@power_off_sequence_setting                  = 0x03
      @@power_on                                    = 0x04
      @@power_on_measure                            = 0x05
      @@booster_soft_start                          = 0x06
      @@deep_sleep                                  = 0x07
      @@data_start_transmission_1                   = 0x10
      @@data_stop                                   = 0x11
      @@display_refresh                             = 0x12
      @@image_process                               = 0x13
      @@lut_for_vcom                                = 0x20
      @@lut_blue                                    = 0x21
      @@lut_white                                   = 0x22
      @@lut_gray_1                                  = 0x23
      @@lut_gray_2                                  = 0x24
      @@lut_red_0                                   = 0x25
      @@lut_red_1                                   = 0x26
      @@lut_red_2                                   = 0x27
      @@lut_red_3                                   = 0x28
      @@lut_xon                                     = 0x29
      @@pll_control                                 = 0x30
      @@temperature_sensor_command                  = 0x40
      @@temperature_calibration                     = 0x41
      @@temperature_sensor_write                    = 0x42
      @@temperature_sensor_read                     = 0x43
      @@vcom_and_data_interval_setting              = 0x50
      @@low_power_detection                         = 0x51
      @@tcon_setting                                = 0x60
      @@tcon_resolution                             = 0x61
      @@spi_flash_control                           = 0x65
      @@revision                                    = 0x70
      @@get_status                                  = 0x71
      @@auto_measurement_vcom                       = 0x80
      @@read_vcom_value                             = 0x81
      @@vcm_dc_setting                              = 0x82

      @@rst_pin                                     = 17
      @@dc_pin                                      = 25
      @@cs_pin                                      = 8
      @@busy_pin                                    = 24

      def busy_pin()        @@busy_pin end
      def rst_pin()         @@rst_pin  end
      def dc_pin()          @@dc_pin   end
      def cs_pin()          @@cs_pin   end
      def width()           @@width    end
      def height()          @@height   end
      def refresh_command()
        @@display_refresh
      end
      def new_frame_command
        @@data_start_transmission_1
      end

      def pre_command
        [[:write, @@dc_pin, :low]]
      end

      def pre_data
        [[:write, @@dc_pin, :high]]
      end

      def init
        [[:reset],
         [:command, @@power_setting, 0x37, 0x00],
         [:command, @@panel_setting, 0xCF, 0x08],
         [:command, @@booster_soft_start, 0xc7, 0xcc, 0x28],
         [:command, @@power_on],
         [:wait],
         [:command, @@pll_control, 0x3c],
         [:command, @@temperature_calibration, 0x00],
         [:command, @@vcom_and_data_interval_setting, 0x77],
         [:command, @@tcon_setting, 0x22],
         [:command, @@tcon_resolution, 0x02, 0x80, 0x01, 0x80],
         [:command, @@vcm_dc_setting, 0x1E],
         [:command, 0xe5, 0x03]]
      end
    end
  end
end
