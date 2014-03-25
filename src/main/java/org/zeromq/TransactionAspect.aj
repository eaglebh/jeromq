package org.zeromq;

public aspect TransactionAspect {

	pointcut orgzeromq() : cflow( execution(* org.zeromq.Test*.*(..)) ) && !within( TransactionAspect );    

	before() :  orgzeromq() && !get( *  *) && !set( *  *) && !execution( * *(..)) && !call(* get(..)) && !call(* hashCode(..))  && !call(* equals(..)) {
            System.out.println(thisEnclosingJoinPointStaticPart.getSignature().getDeclaringType().getName() );
    }
}
