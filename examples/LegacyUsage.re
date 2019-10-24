type action =
  | Tick
  | Reset;

type state = {elapsed: int};

[@react.component]
let make = () => {
  let (state, send) =
    ReactUpdateLegacy.useReducer({elapsed: 0}, (action, state) =>
      switch (action) {
      | Tick =>
        UpdateWithSideEffects(
          {elapsed: state.elapsed + 1},
          ({send}) =>
            Js.Global.setTimeout(() => send(Tick), 1_000)->ignore,
        )
      | Reset => Update({elapsed: 0})
      }
    );
  React.useEffect0(() => {
    send(Tick);
    None;
  });
  <div>
    {state.elapsed->Js.String.make->React.string}
    <button onClick={_ => send(Reset)}> "Reset"->React.string </button>
  </div>;
};
