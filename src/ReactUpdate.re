open Belt;

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
}
and fullState('action, 'state) = {
  state: 'state,
  sideEffects: ref(array(self('action, 'state) => option(unit => unit))),
};

let useReducer = (initialState, reducer) => {
  let ({state, sideEffects}, send) =
    React.useReducer(
      ({state, sideEffects} as fullState, action) =>
        switch (reducer(action, state)) {
        | NoUpdate => fullState
        | Update(state) => {...fullState, state}
        | UpdateWithSideEffects(state, sideEffect) => {
            state,
            sideEffects: ref(Array.concat(sideEffects^, [|sideEffect|])),
          }
        | SideEffects(sideEffect) => {
            ...fullState,
            sideEffects:
              ref(Array.concat(fullState.sideEffects^, [|sideEffect|])),
          }
        },
      {state: initialState, sideEffects: ref([||])},
    );
  React.useEffect1(
    () =>
      if (Array.length(sideEffects^) > 0) {
        let cancelFuncs =
          Array.keepMap(sideEffects^, func => func({state, send}));
        sideEffects := [||];
        Array.length(cancelFuncs) > 0
          ? Some(() => cancelFuncs->Array.forEach(func => func())) : None;
      } else {
        None;
      },
    [|sideEffects|],
  );
  (state, send);
};
