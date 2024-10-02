// ******************************************************************
//                              FUND MANAGER TEST
// ******************************************************************
use starknet::{ContractAddress, contract_address_const};
use starknet::class_hash::{ClassHash};
use starknet::syscalls::deploy_syscall;

use snforge_std::{
    ContractClass, declare, ContractClassTrait, start_cheat_caller_address_global, get_class_hash
};

use openzeppelin::utils::serde::SerializedAppend;

use gostarkme::fundManager::IFundManagerDispatcher;
use gostarkme::fundManager::IFundManagerDispatcherTrait;

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn __setup__() -> (ContractAddress, ClassHash){
    // Fund
    let fund = declare("Fund").unwrap();
    let mut fund_calldata: Array<felt252> = array![];
    fund_calldata.append_serde(OWNER());
    let (fund_contract_address, _) = fund.deploy(@fund_calldata).unwrap();
    let fund_class_hash = get_class_hash(fund_contract_address);

    // Fund Manager
    let fund_manager = declare("FundManager").unwrap();
    let mut fund_manager_calldata: Array<felt252> = array![];
    fund_manager_calldata.append_serde(fund_class_hash);
    let (contract_address, _) = fund_manager.deploy(@fund_manager_calldata).unwrap();
    
    return (contract_address, fund_class_hash,);
}

// *************************************************************************
//                              TEST
// *************************************************************************

#[test]
fn test_constructor() {
    start_cheat_caller_address_global(OWNER());
    let (contract_address, fund_class_hash) = __setup__();

}