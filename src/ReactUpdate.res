open Belt

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
and fullState<'action, 'state> = {
  state: 'state,
  sideEffects: ref<array<self<'action, 'state> => option<unit => unit>>>,
}

type reducer<'state, 'action> = ('state, 'action) => update<'action, 'state>

let useReducer = (reducer, initialState) => {
  let cleanupEffects = React.useRef([])
  let ({state, sideEffects}, send) = React.useReducer(({state, sideEffects} as fullState, action) =>
    switch reducer(state, action) {
    | NoUpdate => fullState
    | Update(state) => {...fullState, state: state}
    | UpdateWithSideEffects(state, sideEffect) => {
        state: state,
        sideEffects: ref(Array.concat(sideEffects.contents, [sideEffect])),
      }
    | SideEffects(sideEffect) => {
        ...fullState,
        sideEffects: ref(Array.concat(fullState.sideEffects.contents, [sideEffect])),
      }
    }
  , {state: initialState, sideEffects: ref([])})
  React.useEffect1(() => {
    if Array.length(sideEffects.contents) > 0 {
      let sideEffectsToRun = Js.Array.sliceFrom(0, sideEffects.contents)
      sideEffects := []
      let cancelFuncs = Array.keepMap(sideEffectsToRun, func =>
        func({state: state, send: send, dispatch: send})
      )
      let _ = cleanupEffects.current->Js.Array2.pushMany(cancelFuncs)
    }
    None
  }, [sideEffects])

  React.useEffect0(() => {
    Some(() => cleanupEffects.current->Js.Array2.forEach(cb => cb()))
  })
  (state, send)
}

let useReducerWithMapState = (reducer, getInitialState) => {
  let cleanupEffects = React.useRef([])
  let ({state, sideEffects}, send) = React.useReducerWithMapState(
    ({state, sideEffects} as fullState, action) =>
      switch reducer(state, action) {
      | NoUpdate => fullState
      | Update(state) => {...fullState, state: state}
      | UpdateWithSideEffects(state, sideEffect) => {
          state: state,
          sideEffects: ref(Array.concat(sideEffects.contents, [sideEffect])),
        }
      | SideEffects(sideEffect) => {
          ...fullState,
          sideEffects: ref(Array.concat(fullState.sideEffects.contents, [sideEffect])),
        }
      },
    (),
    () => {state: getInitialState(), sideEffects: ref([])},
  )
  React.useEffect1(() => {
    if Array.length(sideEffects.contents) > 0 {
      let sideEffectsToRun = Js.Array.sliceFrom(0, sideEffects.contents)
      sideEffects := []
      let cancelFuncs = Array.keepMap(sideEffectsToRun, func =>
        func({state: state, send: send, dispatch: send})
      )
      let _ = cleanupEffects.current->Js.Array2.pushMany(cancelFuncs)
    }
    None
  }, [sideEffects])

  React.useEffect0(() => {
    Some(() => cleanupEffects.current->Js.Array2.forEach(cb => cb()))
  })
  (state, send)
}
