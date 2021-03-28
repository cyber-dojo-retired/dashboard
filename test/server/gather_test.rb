require_relative 'test_base'
require_source 'helpers/app_helpers'
require_source 'helpers/gatherer'

class GatheredTest < TestBase

  def self.id58_prefix
    '450'
  end

  include AppHelpers

  def params
    @params
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 's46',
  'gather from saved cyber-dojo group v0' do
    id = 'chy6BJ'
    expected_indexes = {
      'k5ZTk0' => 11,
    }
    expected_lights = {
      'k5ZTk0' => [
        tcp([2019, 1, 19, 12, 45, 19, 994317], :red,   'none'),
        tcp([2019, 1, 19, 12, 45, 26, 76791],  :amber, 'none'),
        tcp([2019, 1, 19, 12, 45, 30, 656924], :green, 'none'),
      ]
    }
    old_gather_check(id, expected_indexes, expected_lights)
    new_gather_check(id, expected_indexes, expected_lights)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 's47',
  'gather from saved cyber-dojo group v1' do
    id = 'LyQpFr'
    expected_indexes = {
      'rUqcey' => 26,
      '38w9NC' => 27,
    }
    expected_lights = {
      'rUqcey' => [
        tcp([2020, 11, 30, 14, 6, 39, 366362], :green, 'none'),
        tcp([2020, 11, 30, 14, 6, 53, 941739], :green, 'none')
      ],
      '38w9NC' => [
        tcp([2020, 11, 30, 14, 7, 28, 706554], :red, 'none'),
      ]
    }
    old_gather_check(id, expected_indexes, expected_lights)
    new_gather_check(id, expected_indexes, expected_lights)    
  end

  def old_gather_check(id, expected_indexes, expected_lights)
    @params = { id:id }
    gather
    assert_equal expected_indexes, @all_indexes
    actual_lights = {}
    expected_indexes.keys.each do |id|
      actual_lights[id] = flat_lights(id)
    end
    assert_equal expected_lights, actual_lights    
  end

  def new_gather_check(id, expected_indexes, expected_lights)
    gather2(id)
    assert_equal expected_indexes, @all_indexes
    assert_equal expected_lights, @all_lights    
  end

  def gather2(id)
    # Intention is to use this instead of gather() in helpers/gatherer.rb
    # as part of switching away from saver and to model.
    @all_lights = {}
    @all_indexes = {}    
    externals.model.group_joined(id).each do |index,o|
      lights = []
      o['events'].each do |event|
        if event.has_key?('colour')
          event.delete('index')
          event.delete('duration')
          colour = event.delete('colour')
          event['colour'] = colour.to_sym
          time = event.delete('time')
          event['time_a'] = time
          lights << event
        end
      end
      unless lights == []
        @all_indexes[o['id']] = index.to_i
        @all_lights[o['id']] = lights
      end
    end  
  end

  private

  def tcp(time_a, colour, predicted)
    {
      'time_a' => time_a,
      'colour' => colour,
      'predicted' => predicted
    }
  end

  def flat_lights(id)
    actual = []
    @all_lights[id].each do |light|
      actual << tcp(light.time_a, light.colour, light.predicted)
    end
    actual
  end

end
