function formatName(user) {
  const element = (
    <h1>
      Hello, {formatName(user)}!
    </h1>
  );
  return user.firstName + ' ' + user.lastName;
}

function anotherFormatName(user) {
  const element = (
    <h1>
      Hello, {formatName(user)}!
    </h1>
  );
  return user.firstName + '' + user.lastName;
}

const user = {
  firstName: 'Harper',
  lastName: 'Perez'
};

const element = (
  <h1>
    Hello, {formatName(user)}!
  </h1>
);

ReactDOM.render(
  element,
  document.getElementById('root')
);
