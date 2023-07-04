import React, { useState } from "react";
import FolderIcon from "@mui/icons-material/Folder";
import InsertdriveIcon from "@mui/icons-material/InsertDriveFile";
import QueryIcon from "@mui/icons-material/QueryStats";
import "../index.css";
import MenuIcon from "@mui/icons-material/Menu";

export default () => {
  const onDragStart = (event, nodeTypes) => {
    event.dataTransfer.setData("application/reactflow", nodeTypes);
    event.dataTransfer.effectAllowed = "move";
  };

  return (
    <div className="sidebar">
      <div className="demo_box">
        <div className="upper_div">
          <MenuIcon></MenuIcon>
          <h4>Objects</h4>
        </div>
        <div
          onDragStart={(event) => onDragStart(event, "MsDataNode")}
          draggable
        >
          <FolderIcon
            style={{ fontSize: "6em", color: "orange", cursor: "pointer" }}
          />
        </div>
        <h4>MsData</h4>
      </div>
      <div className="demo_box">
        <div className="upper_div">
          <MenuIcon></MenuIcon>
          <h4>Input</h4>
        </div>
        <div
          onDragStart={(event) => onDragStart(event, "MsAnalysisNode")}
          draggable
        >
          <InsertdriveIcon
            style={{ fontSize: "6em", color: "green", cursor: "pointer" }}
          />
        </div>
        <h4>mzML</h4>
      </div>
      <div className="demo_box">
        <div className="upper_div">
          <MenuIcon></MenuIcon>
          <h4>Ms Pre-Processing</h4>
        </div>
        <div
          onDragStart={(event) => onDragStart(event, "MsProcessingNode")}
          draggable
        >
          <QueryIcon style={{ fontSize: "6em", cursor: "pointer" }} />
        </div>
        <h4>Find Features</h4>
      </div>
    </div>
  );
};
