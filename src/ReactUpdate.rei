type update('action, 'state) =
  | NoUpdate
  | Update('state)
  | UpdateWithSideEffects('state, self('action, 'state) => option(unit => unit))
  | SideEffects(self('action, 'state) => option(unit => unit))
and self('action, 'state) = {
  send: 'action => unit,
  state: 'state,
}
and fullState('action, 'state) = {
  state: 'state,
  sideEffects: ref(array(self('action, 'state) => option(unit => unit))),
};

let useReducer:
  ('state, ('action, 'state) => update('action, 'state)) =>
  ('state, 'action => unit);
