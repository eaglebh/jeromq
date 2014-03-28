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
			outputFile = new File(featureName+".data");
			outputFile.delete();
			usedClasses = new HashSet<String>();
            addToFile("\n" + featureName, false);
		}

		public void addUsedClass(String className) {
			if(!className.contains(this.featureName) && (className.startsWith("zmq") || className.startsWith("org.zeromq")) && className.indexOf('$') == -1) {
				if(!usedClasses.contains(className)) {					
					addToFile(className, true);
					usedClasses.add(className);
				}
			}
		}

        private void addToFile(String className, boolean hasClass) {
			try (OutputStream os = new FileOutputStream(outputFile, true)) {  
                if(hasClass)
                    os.write(", ".getBytes());
                os.write((className.replace('.', '/')+".java").getBytes());
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
		String testName = "org.zeromq.TestProxy";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  orgzeromqZLoop() && exclusion() {
		String testName = "org.zeromq.TestZLoop";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  orgzeromqZMQ() && exclusion() {
		String testName = "org.zeromq.TestZMQ";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  orgzeromqZThread() && exclusion() {
		String testName = "org.zeromq.TestZThread";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqAddress() && exclusion() {
		String testName = "zmq.TestAddress";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqBlob() && exclusion() {
		String testName = "zmq.TestBlob";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqDecoder() && exclusion() {
		String testName = "zmq.TestDecoder";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqEncoder() && exclusion() {
		String testName = "zmq.TestEncoder";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqMsgFlags() && exclusion() {
		String testName = "zmq.TestMsgFlags";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

	before() :  zmqPubSubTcp() && exclusion() {
		String testName = "zmq.TestPubSubTcp";
		generateInfo(testName, thisEnclosingJoinPointStaticPart);
	}

}
