function rpcHooks(context, logger, nk, payload) {
  var result = JSON.stringify({
    message: "ok"
  });
  return result;
}

function InitModule(ctx, logger, nk, initializer) {
  logger.info('MetaTop(Hello-nakama) TypeScript module loaded.');
  initializer.registerRpc("choco.hello", rpcMetatopHello);
  initializer.registerRpc("choco.hooks", rpcHooks);
}

function rpcMetatopHello(context, logger, nk, payload) {
  var result = JSON.stringify({
    message: "ok"
  });
  return result;
}

!InitModule && InitModule.bind(null);
