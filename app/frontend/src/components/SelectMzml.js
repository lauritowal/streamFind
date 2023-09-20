import React, { useEffect, useState } from "react";
import axios from "axios";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import FolderIcon from "@mui/icons-material/Folder";
import HomeIcon from "@mui/icons-material/Home";
import InsertDriveFileIcon from "@mui/icons-material/InsertDriveFile";
import { Button, colors } from "@mui/material";

const SelectMzml = ({ onFolderSelect, onfileName }) => {
  const [folders, setFolders] = useState([]);
  const [selectedFolder, setSelectedFolder] = useState("");
  const [previousFolders, setPreviousFolders] = useState([]);
  const [selectedFiles, setSelectedFiles] = useState([]);
  const [fileName, setfileName] = useState([]);

  useEffect(() => {
    axios
      .get("http://127.0.0.1:8000/files_project")
      .then((response) => {
        console.log(response);
        setFolders(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  const handleSendFiles = () => {
    onFolderSelect(selectedFiles);
    onfileName(fileName);
  };
  const handleDiscard = () => {
    setSelectedFiles([]);
  };

  const handleFolderClick = (item) => {
    if (item.endsWith(".mzML")) {
      const fullPath = selectedFolder + "/" + item;
      setfileName(item.split("/").pop());
      setfileName((prevfileName) => [...prevfileName, fileName]);
      setSelectedFiles((prevSelectedFiles) => [...prevSelectedFiles, fullPath]);
    } else {
      setSelectedFolder(selectedFolder + "/" + item);
      axios
        .post("http://127.0.0.1:8000/open_folder", {
          name: selectedFolder + "/" + item,
        })
        .then((response) => {
          console.log(response);
          console.log(response.data);
          setPreviousFolders((prevFolders) => [...prevFolders, selectedFolder]);
          setFolders(response.data);
        })
        .catch((error) => {
          console.log(error);
        });
    }
  };

  const handleBackClick = () => {
    const prevFolder = previousFolders.pop();
    setSelectedFolder(prevFolder);
    axios
      .post("http://127.0.0.1:8000/open_folder", {
        name: prevFolder,
      })
      .then((response) => {
        setFolders(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  };

  return (
    <div>
      <div>
        <p>
          <HomeIcon style={{ position: "absolute", top: 52, left: 20 }} />{" "}
          {selectedFolder}
        </p>
      </div>
      {selectedFolder !== "" && (
        <ArrowBackIcon
          style={{ cursor: "pointer" }}
          onClick={handleBackClick}
        ></ArrowBackIcon>
      )}
      <div style={{ position: "absolute", top: 130, left: 50 }}>
        {folders.map((item, index) => (
          <li
            key={index}
            style={{
              cursor: "pointer",
            }}
            onClick={() => handleFolderClick(item)}
          >
            {item.endsWith(".mzML") ? (
              <InsertDriveFileIcon
                style={{ color: "green" }}
                onClick={(e) => {
                  e.stopPropagation();
                  handleFolderClick(item);
                }}
              />
            ) : (
              <FolderIcon fontSize="small" style={{ color: "teal" }} />
            )}
            {item}
          </li>
        ))}
      </div>
      <div style={{ position: "absolute", top: 530, left: 50 }}>
        {fileName.length > 0 && <li>{fileName}</li>}
      </div>
      <div style={{ position: "absolute", top: 625 }}>
        {selectedFiles.length > 0 && (
          <Button onClick={handleSendFiles}>Select</Button>
        )}
      </div>
      <div style={{ position: "absolute", top: 625, left: 150 }}>
        {selectedFiles.length > 0 && (
          <Button onClick={handleDiscard}>Discard Selection</Button>
        )}
      </div>
    </div>
  );
};

export default SelectMzml;
