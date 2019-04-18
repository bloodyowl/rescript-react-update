type update('action, 'state) =
  | NoUpdate
  | Update('state)
  | UpdateWithSideEffects(
      'state,
      self('action, 'state) => option(unit => unit),
    )
  | SideEffects(self('action, 'state) => option(unit => unit))
and self('action, 'state) = {
  send: 'action => unit,
  state: 'state,
};

let useReducer:
  ('state, ('action, 'state) => update('action, 'state)) =>
  ('state, 'action => unit);
