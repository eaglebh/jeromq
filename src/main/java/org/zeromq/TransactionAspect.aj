package org.zeromq;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.aspectj.lang.JoinPoint.StaticPart;


public aspect TransactionAspect {

	private class InspectedClass {
		private String featureName;
		private File outputFile;
		private Set<String> usedClasses;

		public InspectedClass(String featureName) {
			this.featureName = featureName;
			outputFile = new File(featureName);
			outputFile.delete();
			usedClasses = new HashSet<String>();
		}

		public void addUsedClass(String className) {
			if(!className.contains("Test"+this.featureName)) {
				if(!usedClasses.contains(className)) {					
					addToFile(className);
					usedClasses.add(className);
				}
			}
		}

		private void addToFile(String className) {
			try (OutputStream os = new FileOutputStream(outputFile, true)) {  
				os.write((" " + className).getBytes());
			} catch (FileNotFoundException ex) {  
				System.err.println("Missing file " + outputFile.getAbsolutePath());  
			} catch (IOException ioEx) {
				System.err.println("IO Err  file " + outputFile.getAbsolutePath());
			}
		}
	}

	private Map<String, InspectedClass> tests;

	TransactionAspect() {
		tests = new HashMap<String, InspectedClass>();
	}

	pointcut orgzeromqProxy() : cflowbelow( execution(* org.zeromq.TestProxy.*(..)) );

	pointcut orgzeromqZLoop() : cflowbelow( execution(* org.zeromq.TestZLoop.*(..)) );    

	pointcut orgzeromqZMQ() : cflowbelow( execution(* org.zeromq.TestZMQ.*(..)) );    

	pointcut orgzeromqZThread() : cflowbelow( execution(* org.zeromq.TestZThread.*(..)) );

	pointcut zmqAddress() : cflowbelow( execution(* zmq.TestAddress.*(..)) );

	pointcut zmqBlob() : cflowbelow( execution(* zmq.TestBlob.*(..)) );

	pointcut zmqDecoder() : cflowbelow( execution(* zmq.TestDecoder.*(..)) );

	pointcut zmqEncoder() : cflowbelow( execution(* zmq.TestEncoder.*(..)) );

	pointcut zmqMsgFlags() : cflowbelow( execution(* zmq.TestMsgFlags.*(..)) );

	pointcut zmqPubSubTcp() : cflowbelow( execution(* zmq.TestPubsubTcp.*(..)) );


	pointcut exclusion() : !get( * *) && !set( * *) && !execution( * *(..)) && !call(* get(..)) && !call(* hashCode(..)) && !call(* equals(..)) && !within( TransactionAspect ) && !within( InspectedClass );

	private void generateInfo(String featureName, Object enclosingJoinPointStaticPart) {
		InspectedClass inspectedClass = tests.get(featureName);
		if(inspectedClass == null) {
			inspectedClass = new InspectedClass(featureName);
			tests.put(featureName, inspectedClass);
		}
		String className = ((StaticPart)enclosingJoinPointStaticPart).getSignature().getDeclaringType().getName();
		inspectedClass.addUsedClass(className);
		//System.out.print("AJ " + featureName + " " + className );
	}
	
	before() :  orgzeromqProxy() && exclusion() {
		String testName = "Proxy";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  orgzeromqZLoop() && exclusion() {
		String testName = "ZLoop";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  orgzeromqZMQ() && exclusion() {
		String testName = "ZMQ";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  orgzeromqZThread() && exclusion() {
		String testName = "ZThread";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqAddress() && exclusion() {
		String testName = "Address";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqBlob() && exclusion() {
		String testName = "Blob";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqDecoder() && exclusion() {
		String testName = "Decoder";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqEncoder() && exclusion() {
		String testName = "Encoder";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqMsgFlags() && exclusion() {
		String testName = "MsgFlags";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqPubSubTcp() && exclusion() {
		String testName = "PubSubTcp";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

}
