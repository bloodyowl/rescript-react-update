# rescript-react-update

> useReducer with updates and side effects!

## Installation

```console
$ yarn add rescript-react-update
```

or

```console
$ npm install --save rescript-react-update
```

Then add `rescript-react-update` to your `bsconfig.json` `bs-dependencies` field.

## ReactUpdate.useReducer

```reason
type state = int;

type action =
  | Increment
  | Decrement;

[@react.component]
let make = () => {
  let (state, send) =
    ReactUpdate.useReducer((state, action) =>
      switch (action) {
      | Increment => Update(state + 1)
      | Decrement => Update(state - 1)
      },
      0
    );
  <div>
    {state->React.int}
    <button onClick={_ => send(Decrement)}> {"-"->React.string} </button>
    <button onClick={_ => send(Increment)}> {"+"->React.string} </button>
  </div>;
};
```

### Lazy initialisation

## ReactUpdate.useReducerWithMapState

If you'd rather initialize state lazily (if there's some computation you don't want executed at every render for instance), use `useReducerWithMapState` where the first argument is a function taking `unit` and returning the initial state.

```reason
type state = int;

type action =
  | Increment
  | Decrement;

[@react.component]
let make = () => {
  let (state, send) =
    ReactUpdate.useReducerWithMapState(
      (state, action) =>
        switch (action) {
        | Increment => Update(state + 1)
        | Decrement => Update(state + 1)
        },
        () => 0
    );
  <div>
    {state->React.int}
    <button onClick={_ => send(Decrement)}> {"-"->React.string} </button>
    <button onClick={_ => send(Increment)}> {"+"->React.string} </button>
  </div>;
};
```

### Cancelling a side effect

The callback you pass to `SideEffects` & `UpdateWithSideEffect` returns an `option(unit => unit)`, which is the cancellation function.

```reason
// doesn't cancel
SideEffects(({send}) => {
  Js.log(1);
  None
});
// cancels
SideEffects(({send}) => {
  let request = Request.make();
  request->Future.get(payload => send(Receive(payload)))
  Some(() => {
    Request.cancel(request)
  })
});
```

If you want to copy/paste old reducers that don't support cancellation, you can use `ReactUpdateLegacy` instead in place of `ReactUpdate`. Its `SideEffects` and `UpdateWithSideEffects` functions accept functions that return `unit`.
