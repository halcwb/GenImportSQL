namespace TestProject
{
    partial class ImportForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ImportButton = new System.Windows.Forms.Button();
            this.FolderLbl = new System.Windows.Forms.Label();
            this.folderLocationLabel = new System.Windows.Forms.Label();
            this.folderBrowserDialog = new System.Windows.Forms.FolderBrowserDialog();
            this.SuspendLayout();
            // 
            // ImportButton
            // 
            this.ImportButton.Location = new System.Drawing.Point(251, 42);
            this.ImportButton.Name = "ImportButton";
            this.ImportButton.Size = new System.Drawing.Size(75, 23);
            this.ImportButton.TabIndex = 0;
            this.ImportButton.Text = "Start Import";
            this.ImportButton.UseVisualStyleBackColor = true;
            this.ImportButton.Click += new System.EventHandler(this.FilePathButtonClick);
            // 
            // FolderLbl
            // 
            this.FolderLbl.AutoSize = true;
            this.FolderLbl.Location = new System.Drawing.Point(13, 13);
            this.FolderLbl.Name = "FolderLbl";
            this.FolderLbl.Size = new System.Drawing.Size(39, 13);
            this.FolderLbl.TabIndex = 1;
            this.FolderLbl.Text = "Folder:";
            // 
            // folderLocationLabel
            // 
            this.folderLocationLabel.AutoSize = true;
            this.folderLocationLabel.Location = new System.Drawing.Point(59, 13);
            this.folderLocationLabel.Name = "folderLocationLabel";
            this.folderLocationLabel.Size = new System.Drawing.Size(0, 13);
            this.folderLocationLabel.TabIndex = 2;
            
            // 
            // ImportForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(338, 80);
            this.Controls.Add(this.folderLocationLabel);
            this.Controls.Add(this.FolderLbl);
            this.Controls.Add(this.ImportButton);
            this.Name = "ImportForm";
            this.Text = "Import G-Standard";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button ImportButton;
        private System.Windows.Forms.Label FolderLbl;
        private System.Windows.Forms.Label folderLocationLabel;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog;
    }
}

