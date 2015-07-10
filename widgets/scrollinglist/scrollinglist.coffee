class Dashing.Scrollinglist extends Dashing.Widget
  onData: (data) ->
    new_items = [data.item]
    current_items = @get('items')
    for current_item in current_items
      new_items.push(current_item)
    @set('items', new_items[0..50])
