public with sharing class FileUploadController {
   private String DOCUMENT_FOLDER_NAME = 'FolderName';
   public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }

  public PageReference upload() {

    document.AuthorId = UserInfo.getUserId();
    //Get folder
    List<Folder> folders = [SELECT ID from Folder where Name =: DOCUMENT_FOLDER_NAME ];
    if(folders.size() == 0){
   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Folder in Documents does not exist'));
        return null;
    }
    if(folders.size() != 1){
   		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Multiple folders existing matching name ' + DOCUMENT_FOLDER_NAME));
    	return null;
    }
    document.FolderId = folders[0].ID;

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
      return null;
    } finally {
      document.body = null; // clears the viewstate
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    return null;
  }

}
