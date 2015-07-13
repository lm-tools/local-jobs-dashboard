class Dashing.Jobs extends Dashing.Widget

  ready: ->
    @set('first_time', true)

  onData: (data) ->
    first_time = @get('first_time')
    if first_time
      new_items  = data.first_items
      @set('first_time', false)
    else
      new_items = [data.item]
    current_items = @get('items')
    for current_item in current_items
      new_items.push(current_item)
    @set('items', new_items[0..10])
