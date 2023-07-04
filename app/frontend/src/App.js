import React, { useState, useRef, useCallback, useEffect } from "react";
import ReactFlow, {
  Background,
  ReactFlowProvider,
  addEdge,
  useNodesState,
  useEdgesState,
  Controls,
} from "reactflow";
import "reactflow/dist/style.css";
import "./index.css";
import Sidebar from "./Components/Sidebar";
import MsData from "./Components/NodeTypes/MsData";
import MsAnalysis from "./Components/NodeTypes/MsAnalysis";
import MsProcessing from "./Components/NodeTypes/MsProcessing";

const initialNodes = [];
const nodeTypes = {
  MsDataNode: MsData,
  MsAnalysisNode: MsAnalysis,
  MsProcessingNode: MsProcessing,
};

let id = 0;
const getId = (type) => `${type}${id++}`;

const Canvas = () => {
  const reactFlowWrapper = useRef(null);
  const [nodes, setNodes, onNodesChange] = useNodesState(initialNodes);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);
  const [reactFlowInstance, setReactFlowInstance] = useState(null);
  const [inputFiles, setInputFiles] = useState([]);

  const onConnect = useCallback(
    (params) => {
      const newEdge = addEdge(params, edges);
      setEdges(newEdge);
      // Update the data property of the source node
      const sourceNode = nodes.find((node) => node.id === params.source);
      if (sourceNode) {
        const updatedSourceNode = {
          ...sourceNode,
          data: {
            ...sourceNode.data,
            edges: [...sourceNode.data.edges, params],
          },
        };
        setNodes((nodes) =>
          nodes.map((node) =>
            node.id === params.source ? updatedSourceNode : node
          )
        );
      }
    },
    [edges, nodes]
  );

  const onDragOver = useCallback((event) => {
    event.preventDefault();
    event.dataTransfer.dropEffect = "move";
  }, []);

  console.log(nodes);

  const onDrop = useCallback(
    (event) => {
      event.preventDefault();

      const reactFlowBounds = reactFlowWrapper.current.getBoundingClientRect();
      const type = event.dataTransfer.getData("application/reactflow");

      // check if the dropped element is valid
      if (typeof type === "undefined" || !type) {
        return;
      }

      const position = reactFlowInstance.project({
        x: event.clientX - reactFlowBounds.left,
        y: event.clientY - reactFlowBounds.top,
      });
      const newNode = {
        id: getId(type),
        type: type,
        position,
        data: {
          label: `${type}`,
          edges: [],
          inputFiles: [],
          setNodes: setNodes,
        },
      };
      setNodes((nds) => nds.concat(newNode));
    },
    [reactFlowInstance]
  );

  return (
    <div className="dndflow">
      <ReactFlowProvider>
        <Background />
        <div className="reactflow-wrapper" ref={reactFlowWrapper}>
          <ReactFlow
            nodes={nodes}
            nodeTypes={nodeTypes}
            edges={edges}
            onNodesChange={onNodesChange}
            onEdgesChange={onEdgesChange}
            onConnect={onConnect}
            onInit={setReactFlowInstance}
            onDrop={onDrop}
            onDragOver={onDragOver}
            fitView
          ></ReactFlow>
        </div>
        <Controls position="bottom-right" />
      </ReactFlowProvider>
      <Sidebar />
    </div>
  );
};

export default Canvas;
