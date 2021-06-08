type dispatch<'action> = 'action => unit

type rec update<'state, 'action> =
  | NoUpdate
  | Update('state)
  | UpdateWithSideEffects('state, self<'state, 'action> => option<unit => unit>)
  | SideEffects(self<'state, 'action> => option<unit => unit>)
and self<'state, 'action> = {
  send: 'action => unit,
  dispatch: 'action => unit,
  state: 'state,
}

type reducer<'state, 'action> = ('state, 'action) => update<'state, 'action>

let useReducer: (reducer<'state, 'action>, 'state) => ('state, dispatch<'action>)

let useReducerWithMapState: (reducer<'state, 'action>, () => 'state) => ('state, dispatch<'action>)
