require 'fileutils'

ENUMERATIONS = {
  'SDL_AssertState' => 'Int',
  'SDL_AudioFormat' => 'Int',
  'SDL_AudioStatus' => 'Int',
  'SDL_BlendMode' => 'Int',
  #'SDL_EventType' => 'Int',
  'SDL_GLattr' => 'Int',
  'SDL_GLcontextFlag' => 'Int',
  'SDL_GLprofile' => 'Int',
  'SDL_GameControllerAxis' => 'Int',
  'SDL_GameControllerButton' => 'Int',
  'SDL_HintPriority' => 'Int',
  'SDL_HitTestResult' => 'Int',
  'SDL_JoystickPowerLevel' => 'Int',
  'SDL_Keycode' => 'Int',
  'SDL_LOG_CATEGORY' => 'Int',
  'SDL_LogPriority' => 'Int',
  'SDL_MessageBoxColorType' => 'Int',
  'SDL_PixelFormatEnum' => 'Int',
  'SDL_PowerState' => 'Int',
  'SDL_RendererFlags' => 'Int',
  'SDL_SYSWM_TYPE' => 'Int',
  'SDL_Scancode' => 'Int',
  'SDL_TextureAccess' => 'Int',
  'SDL_TextureModulate' => 'Int',
  'SDL_ThreadPriority' => 'Int',
  'SDL_WinRT_Path' => 'Int',
  'SDL_WindowEventID' => 'UInt8',
  'SDL_Keymod' => 'UInt32',
  'SDL_MessageBoxButtonFlags' => 'UInt32',
  'SDL_MessageBoxFlags' => 'UInt32',
  'SDL_RendererFlip' => 'UInt32',
  'SDL_WindowFlags' => 'UInt32'
}

DEFS = [
  { :type => 'Int',
    :values => []
  },
  { :type => 'UInt32',
    :values => %w(
      SDL_INIT_TIMER
      SDL_INIT_AUDIO
      SDL_INIT_VIDEO
      SDL_INIT_JOYSTICK
      SDL_INIT_HAPTIC
      SDL_INIT_GAMECONTROLLER
      SDL_INIT_EVENTS
      SDL_INIT_NOPARACHUTE
      SDL_INIT_EVERYTHING

      KMOD_CTRL
      KMOD_SHIFT
      KMOD_ALT
      KMOD_GUI
    )
  },
  { :type => 'Int32',
    :values => %w(
      SDL_WINDOWPOS_UNDEFINED
      SDL_WINDOWPOS_CENTERED
    )
  },
  # { :type => 'UInt8',
  #   :values => %w(
  #     SDL_BUTTON_LEFT
  #     SDL_BUTTON_MIDDLE
  #     SDL_BUTTON_RIGHT
  #     SDL_BUTTON_X1
  #     SDL_BUTTON_X2
  #   )
  # }
]

KEYS = DEFS[0]

# Configuration
# TODO: these constants should be populated automatically
# For now, you'll need to futz with it yourself.

# Prefix for SDL2 installation e.g. "/usr", "/usr/local"
PREFIX = ARGV[0]
PATH = PREFIX + "/include"

# SDL header files to scan for enums, relative to PATH
SDL_HEADER_GLOB = "SDL2/SDL*.h"

BLACKLIST_FILES = [/SDL_test/, /opengles/]
BLACKLIST_DEFS = [/WINRT/, /SDL_SYSWM/]

includes = ["SDL2/SDL.h"]
if RUBY_PLATFORM =~ /linux/
  includes += ["GL/gl.h", "GL/glu.h"]
end

# Index all of the enums
Dir.chdir(PATH) do
  these_values = nil
  Dir[SDL_HEADER_GLOB].each do |file|
    next if BLACKLIST_FILES.any? { |b| file =~ b }
    includes << file
    state = :out
    File.open(file).each_line do |line|
      case state
      when :out
        if line =~ /typedef\s+enum/
          state = :in
          these_values = []
        elsif line =~ /enum/
          state = :in_anon
        end
      when :in
        if line =~ /\s*\}\s+(\w+)/
          state = :out
          if ENUMERATIONS[$1]
            DEFS << { :type => ENUMERATIONS[$1], :values => these_values }
          end
        elsif line =~ /^\s*((KMOD|SDL)_\w+)/
          these_values << $1
        end
      when :in_anon
        if line =~ /\s*\}/
          state = :out
        elsif line =~ /^\s*(SDLK_\w+)/
          KEYS[:values] << $1
        end
      end
    end
  end
end

# Remove blacklisted defs
DEFS.each do |ds|
  ds[:values] = ds[:values].reject { |d| BLACKLIST_DEFS.any? { |b| d =~ b } }
end

# Generate a C program to generate a Swift file
puts includes.map { |i| "#include <#{i}>" }.join("\n")
puts "int main() {\n"

DEFS.each do |spec|
  spec[:values].each do |val|
    puts "    printf(\"public let #{val} = #{spec[:type]}(0x%08x)\\n\", #{val});"
  end
end

puts "    return 0;\n"
puts "}\n"
