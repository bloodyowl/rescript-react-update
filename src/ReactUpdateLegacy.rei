type update('action, 'state) =
  | NoUpdate
  | Update('state)
  | UpdateWithSideEffects('state, self('action, 'state) => unit)
  | SideEffects(self('action, 'state) => unit)
and self('action, 'state) = {
  send: 'action => unit,
  state: 'state,
};

let useReducer:
  ('state, ('action, 'state) => update('action, 'state)) =>
  ('state, 'action => unit);

let useReducerWithMapState:
  (unit => 'state, ('action, 'state) => update('action, 'state)) =>
  ('state, 'action => unit);
