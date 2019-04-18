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
      | Decrement => Update(state + 1)
      }
    );
  <div>
    {state->Js.String.make->React.string}
    <button onClick={_ => send(Decrement)}> "-"->React.string </button>
    <button onClick={_ => send(Increment)}> "+"->React.string </button>
  </div>;
};
