const {
    getPK, network
  } = require('./wallet');
  const {
    makeContractCall,
    callReadOnlyFunction,
    AnchorMode,
    PostConditionMode,
    uintCV,
    contractPrincipalCV,
    broadcastTransaction,
    ClarityType
  } = require('@stacks/transactions');
  const {wait_until_confirmation} = require('./utils');
  const { principalCV } = require('@stacks/transactions/dist/clarity/types/principalCV');
  
  
  const setUsdaAmount = async (amount) => {
    console.log('[Faucet] set-usda-amount...', amount);
    const privateKey = await getPK();
    const txOptions = {
        contractAddress: process.env.ACCOUNT_ADDRESS,
        contractName: 'faucet',
        functionName: 'set-usda-amount',
        functionArgs: [         
            uintCV(amount)
        ],
        senderKey: privateKey,
        validateWithAbi: true,
        network,
        anchorMode: AnchorMode.Any,
        postConditionMode: PostConditionMode.Allow,
    };
    try {
        const transaction = await makeContractCall(txOptions);
        const broadcastResponse = await broadcastTransaction(transaction, network);
        console.log(broadcastResponse);
        await wait_until_confirmation(broadcastResponse.txid);
    } catch (error) {
        console.log(error);
    }
  }

  const setWbtcAmount = async (amount) => {
    console.log('[Faucet] set-wbtc-amount...', amount);
    const privateKey = await getPK();
    const txOptions = {
        contractAddress: process.env.ACCOUNT_ADDRESS,
        contractName: 'faucet',
        functionName: 'set-wbtc-amount',
        functionArgs: [         
            uintCV(amount)
        ],
        senderKey: privateKey,
        validateWithAbi: true,
        network,
        anchorMode: AnchorMode.Any,
        postConditionMode: PostConditionMode.Allow,
    };
    try {
        const transaction = await makeContractCall(txOptions);
        const broadcastResponse = await broadcastTransaction(transaction, network);
        console.log(broadcastResponse);
        await wait_until_confirmation(broadcastResponse.txid);
    } catch (error) {
        console.log(error);
    }
  }

  const setStxAmount = async (amount) => {
    console.log('[Faucet] set-stx-amount...', amount);
    const privateKey = await getPK();
    const txOptions = {
        contractAddress: process.env.ACCOUNT_ADDRESS,
        contractName: 'faucet',
        functionName: 'set-stx-amount',
        functionArgs: [         
            uintCV(amount)
        ],
        senderKey: privateKey,
        validateWithAbi: true,
        network,
        anchorMode: AnchorMode.Any,
        postConditionMode: PostConditionMode.Allow,
    };
    try {
        const transaction = await makeContractCall(txOptions);
        const broadcastResponse = await broadcastTransaction(transaction, network);
        console.log(broadcastResponse);
        await wait_until_confirmation(broadcastResponse.txid);
    } catch (error) {
        console.log(error);
    }
  }

  const getSomeTokens = async () => {
    console.log('[Faucet] get some tokens...');
    const privateKey = await getPK();
    const txOptions = {
        contractAddress: process.env.ACCOUNT_ADDRESS,
        contractName: 'faucet',
        functionName: 'get-some-tokens',
        functionArgs: [         
        ],
        senderKey: privateKey,
        validateWithAbi: true,
        network,
        anchorMode: AnchorMode.Any,
        postConditionMode: PostConditionMode.Allow,
    };
    try {
        const transaction = await makeContractCall(txOptions);
        const broadcastResponse = await broadcastTransaction(transaction, network);
        console.log(broadcastResponse);
        await wait_until_confirmation(broadcastResponse.txid);
    } catch (error) {
        console.log(error);
    }
  }  
  
  exports.setUsdaAmount = setUsdaAmount;
  exports.setWbtcAmount = setWbtcAmount;
  exports.setStxAmount = setStxAmount;
  exports.getSomeTokens = getSomeTokens;
  