# reason-react-update

> useReducer with updates and side effects!

## Installation

```console
$ yarn add reason-react-update
```

or

```console
$ npm install --save reason-react-update
```

Then add `reason-react-update` to your `bsconfig.json` `bs-dependencies` field.

## ReactUpdate.useReducer

```reason
type state = int;

type action =
  | Increment
  | Decrement;

[@react.component]
let make = () => {
  let (state, send) =
    ReactUpdate.useReducer(0, (action, state) =>
      switch (action) {
      | Increment => Update(state + 1)
      | Decrement => Update(state - 1)
      }
    );
  <div>
    {state->Js.String.make->React.string}
    <button onClick={_ => send(Decrement)}> "-"->React.string </button>
    <button onClick={_ => send(Increment)}> "+"->React.string </button>
  </div>;
};
```

### Lazy initialisation

## ReactUpdate.useReducer

If you'd rather initialize state lazily (if there's so computation you don't want executed at every render for instance), use `useReducerWithMapState` where the first argument is a function taking `unit` and returning the initial state.

```reason
type state = int;

type action =
  | Increment
  | Decrement;

[@react.component]
let make = () => {
  let (state, send) =
    ReactUpdate.useReducerWithMapState(
      () => 0,
      (action, state) =>
        switch (action) {
        | Increment => Update(state + 1)
        | Decrement => Update(state + 1)
        }
    );
  <div>
    {state->Js.String.make->React.string}
    <button onClick={_ => send(Decrement)}> "-"->React.string </button>
    <button onClick={_ => send(Increment)}> "+"->React.string </button>
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
