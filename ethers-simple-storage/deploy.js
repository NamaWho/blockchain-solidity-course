// synchronous [solidity]
// asynchrounous [javascript]

// Synchronous action:
// 1. Put popcorn in microwave
// 2. Wait for popcorn to finish
// 3. Pour drinks for everyone [------]

// Asynchronous action:
// 1. Put popcorn in microwave --> Promise
// 2. Pour drinks for everyone [not related to the other actions, so there is no need to wait them to be finished]
// 3. Wait for popcorn to finish

// Promise
// > Pending
// > Fulfilled
// > Rejected

async function main() {
  console.log("hello");
  let variable = 5;
  console.log(variable);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
