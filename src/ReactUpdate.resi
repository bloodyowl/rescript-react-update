type dispatch<'action> = 'action => unit

type rec update<'action, 'state> =
  | NoUpdate
  | Update('state)
  | UpdateWithSideEffects('state, self<'action, 'state> => option<unit => unit>)
  | SideEffects(self<'action, 'state> => option<unit => unit>)
and self<'action, 'state> = {
  send: dispatch<'action>,
  dispatch: dispatch<'action>,
  state: 'state,
}

type reducer<'state, 'action> = ('state, 'action) => update<'action, 'state>

let useReducer: (reducer<'state, 'action>, 'state) => ('state, dispatch<'action>)

let useReducerWithMapState: (reducer<'state, 'action>, () => 'state) => ('state, dispatch<'action>)
