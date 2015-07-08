class Dashing.Scrollinglist extends Dashing.Widget
  onData: (data) ->
    items = [data.item]
    for item in @get('items')
      items.push(item)
    @set('items', items)
