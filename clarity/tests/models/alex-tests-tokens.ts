import {
  Account,
  Chain,
  Clarinet,
  Tx,
  types,
} from "https://deno.land/x/clarinet@v0.13.0/index.ts";


class ALEXToken {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("token-alex", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }

  getBalance(account: string) {
    return this.chain.callReadOnlyFn("token-alex", "get-balance", [
      types.principal(account),
    ], this.deployer.address);
  }

  // Always need to called by deployer
  mint(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-alex", "mint", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  mintFixed(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-alex", "mint-fixed", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }
  
  transferToken(sender: Account, amount: number, receiver: string, memo:ArrayBuffer) {
    let block = this.chain.mineBlock([
        Tx.contractCall("token-alex", "transfer-fixed", [
          types.uint(amount),
          types.principal(sender.address),
          types.principal(receiver),
          types.some(types.buff(memo))
        ], sender.address),
      ]);
      return block.receipts[0].result;
  }

  totalSupply() {
    return this.chain.callReadOnlyFn("token-alex", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { ALEXToken };

class USDAToken {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("token-usda", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }

  getBalance(account: string) {
    return this.chain.callReadOnlyFn("token-usda", "get-balance", [
      types.principal(account),
    ], this.deployer.address);
  }

  // Always need to called by deployer
  mint(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-usda", "mint", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  mintFixed(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-usda", "mint-fixed", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  transferToken(sender: Account, amount: number, receiver: string, memo:ArrayBuffer) {
    let block = this.chain.mineBlock([
        Tx.contractCall("token-usda", "transfer-fixed", [
          types.uint(amount),
          types.principal(sender.address),
          types.principal(receiver),
          types.some(types.buff(memo))
        ], sender.address),
      ]);
      return block.receipts[0].result;
  }

  
  totalSupply() {
    return this.chain.callReadOnlyFn("token-usda", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { USDAToken };


class WBTCToken {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("token-wbtc", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }

  getBalance(account: string) {
    return this.chain.callReadOnlyFn("token-wbtc", "get-balance", [
      types.principal(account),
    ], this.deployer.address);
  }

  // Always need to called by deployer
  mint(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-wbtc", "mint", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  mintFixed(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-wbtc", "mint-fixed", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }
  
  transferToken(sender: Account, amount: number, receiver: string, memo:ArrayBuffer) {
    let block = this.chain.mineBlock([
        Tx.contractCall("token-wbtc", "transfer-fixed", [
          types.uint(amount),
          types.principal(sender.address),
          types.principal(receiver),
          types.some(types.buff(memo))
        ], sender.address),
      ]);
      return block.receipts[0].result;
  }

  totalSupply() {
    return this.chain.callReadOnlyFn("token-wbtc", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { WBTCToken };

class WSTXToken {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("token-wstx", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }

  getBalance(account: string) {
    return this.chain.callReadOnlyFn("token-wstx", "get-balance", [
      types.principal(account),
    ], this.deployer.address);
  }

  // Always need to called by deployer
  mint(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-wstx", "mint", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  mintFixed(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-wstx", "mint-fixed", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  transferToken(sender: Account, amount: number, receiver: string, memo:ArrayBuffer) {
    let block = this.chain.mineBlock([
        Tx.contractCall("token-wstx", "transfer-fixed", [
          types.uint(amount),
          types.principal(sender.address),
          types.principal(receiver),
          types.some(types.buff(memo))
        ], sender.address),
      ]);
      return block.receipts[0].result;
  }
  
  totalSupply() {
    return this.chain.callReadOnlyFn("token-wstx", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { WSTXToken };

class FWP_WSTX_USDA_5050 {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("fwp-wstx-usda-50-50", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply() {
    return this.chain.callReadOnlyFn("fwp-wstx-usda-50-50", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { FWP_WSTX_USDA_5050 };

class FWP_WBTC_USDA_5050 {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("fwp-wbtc-usda-50-50", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply() {
    return this.chain.callReadOnlyFn("fwp-wbtc-usda-50-50", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { FWP_WBTC_USDA_5050 };

class YTP_YIELD_WBTC {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(expiry: number, wallet: string) {
    return this.chain.callReadOnlyFn("ytp-yield-wbtc", "get-balance-fixed", [
      types.uint(expiry), types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply(expiry: number) {
    return this.chain.callReadOnlyFn("ytp-yield-wbtc", "get-total-supply-fixed", [
      types.uint(expiry)
    ], this.deployer.address);
  }
}
export { YTP_YIELD_WBTC };

class YTP_YIELD_USDA {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(expiry: number, wallet: string) {
    return this.chain.callReadOnlyFn("ytp-yield-usda", "get-balance-fixed", [
      types.uint(expiry), types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply(expiry: number) {
    return this.chain.callReadOnlyFn("ytp-yield-usda", "get-total-supply-fixed", [
      types.uint(expiry)
    ], this.deployer.address);
  }
}
export { YTP_YIELD_USDA };

class KEY_USDA_WBTC {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(expiry: number, wallet: string) {
    return this.chain.callReadOnlyFn("key-usda-wbtc", "get-balance-fixed", [
      types.uint(expiry),
      types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply(expiry: number) {
    return this.chain.callReadOnlyFn("key-usda-wbtc", "get-total-supply-fixed", [
      types.uint(expiry)
    ], this.deployer.address);
  }
}
export { KEY_USDA_WBTC };

class KEY_WBTC_USDA {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(expiry: number, wallet: string) {
    return this.chain.callReadOnlyFn("key-wbtc-usda", "get-balance-fixed", [
      types.uint(expiry),
      types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply(expiry: number) {
    return this.chain.callReadOnlyFn("key-wbtc-usda", "get-total-supply-fixed", [
      types.uint(expiry)
    ], this.deployer.address);
  }
}
export { KEY_WBTC_USDA };

class YIELD_WBTC {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(expiry: number, wallet: string) {
    return this.chain.callReadOnlyFn("yield-wbtc", "get-balance-fixed", [
      types.uint(expiry), types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply(expiry: number) {
    return this.chain.callReadOnlyFn("yield-wbtc", "get-total-supply-fixed", [
      types.uint(expiry)
    ], this.deployer.address);
  }
  
  mintFixed(sender: Account, expiry: number, amount: number, recipient: string) {
    let block = this.chain.mineBlock([
      Tx.contractCall("yield-wbtc", "mint-fixed", [
        types.uint(expiry),
        types.uint(amount),
        types.principal(recipient)
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }
}
export { YIELD_WBTC };
class TestALEXLottery {

  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }
  
  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("lottery-t-alex", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }

  getBalance(account: string) {
    return this.chain.callReadOnlyFn("lottery-t-alex", "get-balance", [
      types.principal(account),
    ], this.deployer.address);
  }

  // Always need to called by deployer
  mint(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("lottery-t-alex", "mint", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  mintFixed(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("lottery-t-alex", "mint-fixed", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  transferToken(sender: Account, amount: number, receiver: string, memo:ArrayBuffer) {
    let block = this.chain.mineBlock([
        Tx.contractCall("lottery-t-alex", "transfer-fixed", [
          types.uint(amount),
          types.principal(sender.address),
          types.principal(receiver),
          types.some(types.buff(memo))
        ], sender.address),
      ]);
      return block.receipts[0].result;
  }
  
  totalSupply() {
    return this.chain.callReadOnlyFn("lottery-t-alex", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { TestALEXLottery };

class TestALEXToken {
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(wallet: string) {
    return this.chain.callReadOnlyFn("token-t-alex", "get-balance-fixed", [
      types.principal(wallet),
    ], this.deployer.address);
  }

  getBalance(account: string) {
    return this.chain.callReadOnlyFn("token-t-alex", "get-balance", [
      types.principal(account),
    ], this.deployer.address);
  }

  // Always need to called by deployer
  mint(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-t-alex", "mint", [
        types.uint(amount),
        types.principal(recipient)        
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  mintFixed(sender: Account, recipient: string, amount : number) {
    let block = this.chain.mineBlock([
      Tx.contractCall("token-t-alex", "mint-fixed", [
        types.uint(amount),
        types.principal(recipient)     
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }

  transferToken(sender: Account, amount: number, receiver: string, memo:ArrayBuffer) {
    let block = this.chain.mineBlock([
        Tx.contractCall("token-t-alex", "transfer-fixed", [
          types.uint(amount),
          types.principal(sender.address),
          types.principal(receiver),
          types.some(types.buff(memo))
        ], sender.address),
      ]);
      return block.receipts[0].result;
  }

  totalSupply() {
    return this.chain.callReadOnlyFn("token-t-alex", "get-total-supply-fixed", [], this.deployer.address);
  }
}
export { TestALEXToken };

class YIELD_USDA {
  chain: Chain;
  deployer: Account;
  
  constructor(chain: Chain, deployer: Account) {
    this.chain = chain;
    this.deployer = deployer;
  }

  balanceOf(expiry: number, wallet: string) {
    return this.chain.callReadOnlyFn("yield-usda", "get-balance-fixed", [
      types.uint(expiry), types.principal(wallet),
    ], this.deployer.address);
  }
  
  totalSupply(expiry: number) {
    return this.chain.callReadOnlyFn("yield-usda", "get-total-supply-fixed", [
      types.uint(expiry)
    ], this.deployer.address);
  }
  
  mintFixed(sender: Account, expiry: number, amount: number, recipient: string) {
    let block = this.chain.mineBlock([
      Tx.contractCall("yield-usda", "mint-fixed", [
        types.uint(expiry),
        types.uint(amount),
        types.principal(recipient)
      ], sender.address),
    ]);
    return block.receipts[0].result;
  }
}

export { YIELD_USDA };
