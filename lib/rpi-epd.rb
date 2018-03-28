# -*- coding: utf-8 -*-
require 'devices'
require 'spi'
require 'rpi_gpio'

module RPiEPD
  class EPD
    def initialize(device: nil, spi_file: '/dev/spidev0.0')
      raise "Need a device description" unless device
      @spi = SPI.new(device: spi_file)
      @spi.speed = 2000000
      @device = device
      initialize_pins
      run_commands(@device.init)
    end

    def initialize_pins
      RPi::GPIO.set_numbering :bcm
      RPi::GPIO.set_warnings false
      RPi::GPIO.setup @device.rst_pin,  :as => :output
      RPi::GPIO.setup @device.dc_pin,   :as => :output
      RPi::GPIO.setup @device.cs_pin,   :as => :output
      RPi::GPIO.setup @device.busy_pin, :as => :input
   end

    def digital_write(pin, value)
      case value
      when :high then RPi::GPIO.set_high pin
      when :low then RPi::GPIO.set_low pin
      else raise "WTF"
      end
    end

    def digital_read(pin)
      RPi::GPIO.high?(pin) ? 1 : 0
    end

    def delay_ms(delaytime)
      sleep(delaytime / 1000.0)
    end

    def spi_transfer(data)
      @spi.xfer(txdata: data)
    end

    def wait_until_idle
      delay_ms(100) while (digital_read(@device.busy_pin) == 0)
    end

    def reset
      digital_write(@device.rst_pin, :low)
      delay_ms(200)
      digital_write(@device.rst_pin, :high)
      delay_ms(200)
    end

    def display_frame(frame_buffer)
      raise "Frame buffer is the wrong size" if frame_buffer.count != (@device.width * (@device.height / 8))
      data = frame_buffer.map do |i|
        temp1, j, result = i, 0, []
        while j < 8 do
          temp2 = (temp1 & 0x80) != 0 ? 0x03 : 0x00
          temp2 = (temp2 << 4) & 0xFF
          temp1 = (temp1 << 1) & 0xFF
          j += 1
          temp2 |= (temp1 & 0x80) != 0 ? 0x03 : 0x00
          temp1 = (temp1 << 1) & 0xFF
          j += 1
          result << temp2
        end
        result
      end.flatten
      send_command(@device.new_frame_command, *data)
      send_command(@device.refresh_command)
      delay_ms(100)
      wait_until_idle
    end

    private
    def send_command(cmd, *data)
      run_commands(@device.pre_command)
      spi_transfer([cmd])
      run_commands(@device.pre_data)
      data&.each{|d| spi_transfer([d])}
    end

    def run_commands(commands)
      commands.each do |command|
        cmd, *data = command
        case cmd
        when :command then send_command(*data)
        when :wait then wait_until_idle
        when :reset then reset
        when :write then digital_write(*data)
        else raise("Don't know this command")
        end
      end
    end
  end
end
